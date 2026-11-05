/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
import 'dart:async';
import 'dart:developer' as developer;

import 'package:meta/meta.dart';
import 'package:scandit_flutter_datacapture_core/src/data_capture_context.dart';
import 'package:scandit_flutter_datacapture_core/src/defaults.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/flutter_event.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/schema_types.dart' as schema;
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/sdk_logger.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/tolerant_payload_parser.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_settings.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/torch_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/macro_mode.dart';

/// Internal access to a [Camera]'s desired-state bookkeeping, for state native changed itself.
mixin PrivateCamera {
  FrameSourceState _desiredState = FrameSourceState.off;

  /// Mirrors a state native already switched to, without the `switchCameraToDesiredState`
  /// round-trip that re-sending it would cost.
  @internal
  void adoptDesiredState(FrameSourceState state) {
    _desiredState = state;
  }

  /// The [Camera] the app already created for [position], or null. Not [Camera.atPosition],
  /// which would fabricate one the app never asked for.
  @internal
  static Camera? instanceAtPosition(CameraPosition position) => Camera._cameraInstances[position];
}

/// Gives access to the built-in camera on Flutter. It implements the [FrameSource] interface, and, as such can be set as the frame source for the [DataCaptureContext].
///
/// Instances of this class are created through one of the factory methods defaultCamera(), or atPosition().
///
/// The camera is started by changing the desired state to [FrameSourceState.on].
///
/// By default, the resolution of captured frames as well as auto-focus and exposure settings are chosen such that they work best for a variety of use cases. To fine-tune recognition, the camera settings can be changed through applying new camera settings ([CameraSettings]).
///
/// Added in version 6.7.0
class Camera with PrivateCamera implements FrameSource {
  CameraSettings? _settings;
  late CameraPosition _position;
  TorchState _desiredTorchState = TorchState.off;
  late final _CameraController _cameraController;
  DataCaptureContext? _context;

  final List<FrameSourceListener> _frameSourceListeners = [];
  final List<TorchListener> _torchStateListeners = [];
  final List<MacroModeListener> _macroModeListeners = [];
  final List<ZoomListener> _zoomListeners = [];

  /// The direction that the camera faces.
  ///
  /// Added in version 6.7.0
  CameraPosition get position => _position;

  static final Map<CameraPosition, Camera> _cameraInstances = {};

  FrameSourceState _cameraState = FrameSourceState.off;

  /// Gets the default camera of the device. This method is identical to calling atPosition() repeatedly, first with [CameraPosition.worldFacing], then with [CameraPosition.userFacing] followed by [CameraPosition.unspecified], stopping after the first of these calls returns a non-*null* instance.
  ///
  /// See atPosition() for a more detailed description of the method behavior.
  ///
  /// Added in version 6.7.0
  static Camera? get defaultCamera {
    final defaultPosition = Defaults.cameraDefaults.defaultPosition;
    if (defaultPosition == null) return null;
    return atPosition(defaultPosition);
  }

  /// Implemented from [FrameSource]. See [FrameSource.currentState].
  ///
  /// Added in version 6.7.0
  @override
  Future<FrameSourceState> get currentState => Future(() => _cameraState);

  /// Implemented from [FrameSource]. See [FrameSource.desiredState].
  ///
  /// Added in version 6.7.0
  @override
  FrameSourceState get desiredState => _desiredState;

  Camera._({
    CameraPosition? position,
    CameraSettings? settings,
    TorchState? desiredTorchState,
    FrameSourceState? desiredState,
  }) {
    _position = position ?? Defaults.cameraDefaults.defaultPosition ?? CameraPosition.worldFacing;
    _settings = settings;
    _cameraController = _CameraController(this);
    if (desiredTorchState != null) {
      _desiredTorchState = desiredTorchState;
    }
    if (desiredState != null) {
      _desiredState = desiredState;
    }
  }

  /// Constructs a new camera instance with optional position and settings. This constructor provides a convenient way to create a camera with specific configuration parameters. If no position is specified, the system will attempt to use the default camera. If no settings are provided, default camera settings will be applied.
  ///
  /// Added in version 8.0.0
  factory Camera({
    CameraPosition? position,
    CameraSettings? settings,
    TorchState? desiredTorchState,
    FrameSourceState? desiredState,
  }) {
    final cameraPosition = position ?? Defaults.cameraDefaults.defaultPosition ?? CameraPosition.worldFacing;

    final existingCamera = _cameraInstances[cameraPosition];
    if (existingCamera != null) {
      if (settings != null) {
        existingCamera.applySettings(settings);
      }
      if (desiredTorchState != null) {
        existingCamera.desiredTorchState = desiredTorchState;
      }
      if (desiredState != null) {
        existingCamera.switchToDesiredState(desiredState);
      }
      return existingCamera;
    }

    final camera = Camera._(
      position: cameraPosition,
      settings: settings,
      desiredTorchState: desiredTorchState,
      desiredState: desiredState,
    );
    _cameraInstances[cameraPosition] = camera;
    return camera;
  }

  /// Added in version 8.5.0
  static Camera? withSettings(CameraSettings settings) {
    final camera = defaultCamera;
    if (camera != null) {
      camera.applySettings(settings);
    }
    return camera;
  }

  /// Added in version 8.5.0
  static Camera? atPositionWithSettings(CameraPosition position, CameraSettings settings) {
    final camera = atPosition(position);
    if (camera != null) {
      camera.applySettings(settings);
    }
    return camera;
  }

  /// Retrieves the camera instance of the first camera at the provided position. In case the system does not have a camera at the provided position, *null* is returned.
  ///
  /// When this method is called multiple times with the same argument, the same [Camera] instance is returned. The [FrameSource.currentState] of the camera as well as the settings depend on previous invocations. For example, if the camera is currently in use and is active, the camera’s [FrameSource.currentState] will be [FrameSourceState.on]. The only guarantee about the state and settings is that when instance is initially created, the [FrameSource.currentState] is [FrameSourceState.off] and has the default [CameraSettings].
  ///
  /// In case parts of your app use custom camera settings and others use the default settings, make sure to reset the camera to use the default settings when you need them by passing the default camera settings to applySettings() to ensure that you don’t have any other settings when you’d expect the defaults to be active.
  ///
  /// The camera object is returned if present, regardless whether the application has permissions to use it or not.
  ///
  /// Added in version 6.7.0
  static Camera? atPosition(CameraPosition cameraPosition) {
    if (Defaults.cameraDefaults.availablePositions.contains(cameraPosition) == false) {
      return null;
    }

    return _cameraInstances.putIfAbsent(cameraPosition, () => Camera._(position: cameraPosition));
  }

  /// Returns whether macro mode is available for the current device. See [MacroMode] for details.
  ///
  /// On Android this method will always return `false`.
  ///
  /// Added in version 8.3.0
  static Future<bool> get isMacroModeAvailable async {
    final handler = getCoreMethodHandler();
    final result = await handler.isMacroModeAvailable();
    return result;
  }

  /// The desired torch state for this camera. By default, the torch state is [TorchState.off]. When setting the desired torch state to [TorchState.on], the torch will be on as long as the camera is running (the camera’s state is [FrameSourceState.on]) and off otherwise.
  ///
  /// Added in version 6.7.0
  TorchState get desiredTorchState => _desiredTorchState;

  /// The desired torch state for this camera. By default, the torch state is [TorchState.off]. When setting the desired torch state to [TorchState.on], the torch will be on as long as the camera is running (the camera’s state is [FrameSourceState.on]) and off otherwise.
  ///
  /// Added in version 6.7.0
  set desiredTorchState(TorchState newValue) {
    _desiredTorchState = newValue;
    if (!_isActiveCamera) {
      SdkLogger.warning(
        'Camera',
        'desiredTorchState',
        'The current camera is not added to the DataCaptureContext.',
        'Add camera to the DataCaptureContext first.',
      );
      return;
    }
    _onChange();
  }

  /// Implemented from [FrameSource]. See FrameSource.switchToDesiredState().
  ///
  /// Added in version 6.7.0
  @override
  Future<void> switchToDesiredState(FrameSourceState state) async {
    _desiredState = state;
    if (!_isActiveCamera) {
      SdkLogger.warning(
        'Camera',
        'switchToDesiredState',
        'The current camera is not added to the DataCaptureContext.',
        'Add camera to the DataCaptureContext first.',
      );
      return;
    }
    await _cameraController.switchCameraToDesiredState(state);
  }

  /// Applies the camera settings to the camera. The task will complete when the settings have been applied and the camera has switched to use the new settings. If the camera is currently in [FrameSourceState.off] state, the task will complete immediately. If, on the other hand, the camera is currently in [FrameSourceState.on] state, the settings will be modified on the fly.
  ///
  /// Added in version 6.7.0
  Future<void> applySettings(CameraSettings settings) async {
    _settings = settings;
    if (!_isActiveCamera) {
      return;
    }
    await _onChange();
  }

  /// Whether the torch is available for the given camera.
  ///
  /// Android only: When the camera is off, this method always returns *false*. When the camera is on, it returns *true* for cameras that support the torch, *false* otherwise.
  ///
  /// Added in version 6.7.0
  Future<bool> get isTorchAvailable => _cameraController.isTorchAvailable;

  /// Whether the intensity of this camera’s torch can be varied through [CameraSettings.torchLevel] while the camera is running.
  ///
  /// Added in version 8.7.0
  Future<bool> get isTorchLevelAvailable => _cameraController.isTorchLevelAvailable;

  /// Implemented from [FrameSource]. See [FrameSource.addListener].
  ///
  /// Added in version 6.7.0
  @override
  void addListener(FrameSourceListener? listener) {
    if (listener == null) return;

    if (!_frameSourceListeners.contains(listener)) {
      _frameSourceListeners.add(listener);
    }
  }

  /// Implemented from [FrameSource]. See [FrameSource.removeListener].
  ///
  /// Added in version 6.7.0
  @override
  void removeListener(FrameSourceListener? listener) {
    if (listener == null) return;

    _frameSourceListeners.remove(listener);
  }

  /// Adds a listener that will be called when [TorchState] of the camera changes.
  ///
  /// Added in version 6.12.0
  void addTorchListener(TorchListener listener) {
    if (!_torchStateListeners.contains(listener)) {
      _torchStateListeners.add(listener);
      if (_torchStateListeners.length == 1) {
        _cameraController.subscribeTorchListener();
      }
    }
  }

  /// Removes a listener for [TorchState] changes.
  ///
  /// Added in version 6.12.0
  void removeTorchListener(TorchListener listener) {
    _torchStateListeners.remove(listener);
    if (_torchStateListeners.isEmpty) {
      _cameraController.unsubscribeTorchListener();
    }
  }

  /// Adds a listener that will be called when [MacroMode] of the camera changes.
  ///
  /// This method only works when running on iOS. On Android, macro mode changes will not be reported.
  ///
  /// Added in version 8.3.0
  void addMacroModeListener(MacroModeListener listener) {
    if (!_macroModeListeners.contains(listener)) {
      _macroModeListeners.add(listener);
      if (_macroModeListeners.length == 1) {
        _cameraController.subscribeMacroModeListener();
      }
    }
  }

  /// Removes a listener for [MacroMode] changes.
  ///
  /// Added in version 8.3.0
  void removeMacroModeListener(MacroModeListener listener) {
    _macroModeListeners.remove(listener);
    if (_macroModeListeners.isEmpty) {
      _cameraController.unsubscribeMacroModeListener();
    }
  }

  /// Adds a listener that will be called when the zoom level of the camera changes.
  ///
  /// Added in version 8.4.0
  void addZoomListener(ZoomListener listener) {
    if (!_zoomListeners.contains(listener)) {
      _zoomListeners.add(listener);
      if (_zoomListeners.length == 1) {
        _cameraController.subscribeZoomListener();
      }
    }
  }

  /// Removes a previously added listener for zoom level changes.
  ///
  /// Added in version 8.4.0
  void removeZoomListener(ZoomListener listener) {
    _zoomListeners.remove(listener);
    if (_zoomListeners.isEmpty) {
      _cameraController.unsubscribeZoomListener();
    }
  }

  Future<void> _onChange() async {
    await context?.update();
  }

  /// The context this frame source is attached to. When the frame source is currently not attached to a context, *null* is returned.
  ///
  /// Added in version 6.7.0
  @override
  DataCaptureContext? get context => _context;

  /// The context this frame source is attached to. When the frame source is currently not attached to a context, *null* is returned.
  ///
  /// Added in version 6.7.0
  @override
  set context(DataCaptureContext? context) {
    _context = context;
  }

  bool get _isActiveCamera => _context != null;

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'camera',
      'position': _position.toString(),
      'desiredTorchState': _desiredTorchState.toString(),
      'desiredState': _desiredState.toString(),
      'hasTorchStateListeners': _torchStateListeners.isNotEmpty,
      'hasMacroModeListeners': _macroModeListeners.isNotEmpty,
      'hasZoomListeners': _zoomListeners.isNotEmpty,
    };
    if (_settings != null) {
      json['settings'] = _settings?.toMap();
    }
    return json;
  }
}

class _CameraController extends BaseController {
  final Camera camera;

  StreamSubscription? _stateChangeSubscription;
  StreamSubscription? _torchStateSubscription;
  StreamSubscription? _macroModeSubscription;
  StreamSubscription? _zoomLevelSubscription;
  late CoreMethodHandler cameraMethodHandler;

  _CameraController(this.camera) : super(FunctionNames.methodsChannelName) {
    cameraMethodHandler = CoreMethodHandler(methodChannel);
    cameraMethodHandler.registerFrameSourceListener().then((value) {
      subscribeFrameSourceListener();
    });
  }

  void subscribeFrameSourceListener() {
    if (_stateChangeSubscription != null) return;
    _stateChangeSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventFrameSourceStateChanged)) {
        _handleFrameSourceStateChanged(event);
      }
    });
  }

  void _handleFrameSourceStateChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.FrameSourceListenerOnStateChanged>(
      event.payload,
      (raw) => schema.FrameSourceListenerOnStateChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        if (map['state'] is! String) return null;
        return schema.FrameSourceListenerOnStateChanged(
          state: map['state'] as String,
          cameraPosition: map['cameraPosition'] is String ? map['cameraPosition'] as String : null,
          event: FunctionNames.eventFrameSourceStateChanged,
        );
      },
      'onStateChanged',
      'CameraController',
    );
    if (payload == null) return;

    // Both natives omit cameraPosition entirely for a non-camera frame source (e.g.
    // SequenceFrameSource); an explicit null is also still accepted here, for compatibility
    // with payloads from older native versions. Either way this is a state change of a
    // frame source that carries no cameraPosition at all.
    if (payload.cameraPosition == null) {
      return;
    }
    // The fallback above only checks that these are strings, and both deserializers resolve via
    // `values.firstWhere(...)`, which throws StateError on an out-of-enum value. Declining beats
    // letting that escape into the event stream (SDC-32670).
    final FrameSourceState state;
    final CameraPosition cameraPosition;
    try {
      state = FrameSourceState.fromJSON(payload.state);
      cameraPosition = CameraPosition.fromJSON(payload.cameraPosition!);
    } catch (e) {
      developer.log('CameraController onStateChanged: unrecognised state or cameraPosition: $e');
      return;
    }
    if (cameraPosition != camera.position) {
      // This event is for the other camera most probably, so we can ignore it
      return;
    }
    camera._cameraState = state;
    if (camera._isActiveCamera) {
      _notifyCameraListeners(state);
    }
  }

  void subscribeTorchListener() {
    cameraMethodHandler.registerTorchStateListener().then((value) => _setupTorchSubscription());
  }

  void _setupTorchSubscription() {
    if (_torchStateSubscription != null) return;
    _torchStateSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventTorchStateChanged)) {
        _handleTorchStateChanged(event);
      }
    });
  }

  void _handleTorchStateChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.TorchListenerOnTorchStateChanged>(
      event.payload,
      (raw) => schema.TorchListenerOnTorchStateChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        if (map['state'] is! String) return null;
        return schema.TorchListenerOnTorchStateChanged(
          state: map['state'] as String,
          event: FunctionNames.eventTorchStateChanged,
        );
      },
      'onTorchStateChanged',
      'CameraController',
    );
    if (payload == null) return;

    // The fallback above only checks that this is a string, and the deserializer resolves via
    // `values.firstWhere(...)`, which throws StateError on an out-of-enum value. Declining beats
    // letting that escape into the event stream (SDC-32670).
    final TorchState state;
    try {
      state = TorchState.fromJSON(payload.state);
    } catch (e) {
      developer.log('CameraController onTorchStateChanged: unrecognised state: $e');
      return;
    }
    if (camera._isActiveCamera) {
      camera._desiredTorchState = state;
      _notifyTorchListeners(state);
    }
  }

  void unsubscribeFrameSourceListener() {
    var subscription = _stateChangeSubscription;
    _stateChangeSubscription = null;
    subscription?.cancel();
    cameraMethodHandler.unregisterFrameSourceListener();
  }

  void unsubscribeTorchListener() {
    var subscription = _torchStateSubscription;
    _torchStateSubscription = null;
    subscription?.cancel();
    cameraMethodHandler.unregisterTorchStateListener();
  }

  void subscribeMacroModeListener() {
    cameraMethodHandler.registerMacroModeListener().then((value) => _setupMacroModeSubscription());
  }

  void _setupMacroModeSubscription() {
    if (_macroModeSubscription != null) return;
    _macroModeSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventMacroModeChanged)) {
        _handleMacroModeChanged(event);
      }
    });
  }

  void _handleMacroModeChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.MacroModeListenerOnMacroModeChanged>(
      event.payload,
      (raw) => schema.MacroModeListenerOnMacroModeChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        if (map['macroMode'] is! String) return null;
        return schema.MacroModeListenerOnMacroModeChanged(
          macroMode: map['macroMode'] as String,
          event: FunctionNames.eventMacroModeChanged,
        );
      },
      'onMacroModeChanged',
      'CameraController',
    );
    if (payload == null) return;

    // The fallback above only checks that this is a string, and the deserializer resolves via
    // `values.firstWhere(...)`, which throws StateError on an out-of-enum value. Declining beats
    // letting that escape into the event stream (SDC-32670).
    final MacroMode macroMode;
    try {
      macroMode = MacroMode.fromJSON(payload.macroMode);
    } catch (e) {
      developer.log('CameraController onMacroModeChanged: unrecognised macroMode: $e');
      return;
    }
    if (camera._isActiveCamera) {
      _notifyMacroModeListeners(macroMode);
    }
  }

  void unsubscribeMacroModeListener() {
    var subscription = _macroModeSubscription;
    _macroModeSubscription = null;
    subscription?.cancel();
    cameraMethodHandler.unregisterMacroModeListener();
  }

  void subscribeZoomListener() {
    cameraMethodHandler.registerZoomLevelListener().then((value) => _setupZoomLevelSubscription());
  }

  void _setupZoomLevelSubscription() {
    if (_zoomLevelSubscription != null) return;
    _zoomLevelSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventZoomLevelChanged)) {
        _handleZoomLevelChanged(event);
      }
    });
  }

  void _handleZoomLevelChanged(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.ZoomListenerOnZoomLevelChanged>(
      event.payload,
      (raw) => schema.ZoomListenerOnZoomLevelChanged.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        if (map['oldZoomLevel'] is! num || map['newZoomLevel'] is! num) return null;
        return schema.ZoomListenerOnZoomLevelChanged(
          oldZoomLevel: (map['oldZoomLevel'] as num).toDouble(),
          newZoomLevel: (map['newZoomLevel'] as num).toDouble(),
          event: FunctionNames.eventZoomLevelChanged,
        );
      },
      'onZoomLevelChanged',
      'CameraController',
    );
    if (payload == null) return;

    if (camera._isActiveCamera) {
      _notifyZoomListeners(payload.oldZoomLevel, payload.newZoomLevel);
    }
  }

  void unsubscribeZoomListener() {
    var subscription = _zoomLevelSubscription;
    _zoomLevelSubscription = null;
    subscription?.cancel();
    cameraMethodHandler.unregisterZoomLevelListener();
  }

  Future<bool> get isTorchAvailable {
    return cameraMethodHandler.isTorchAvailable(cameraPosition: camera.position.toString());
  }

  Future<bool> get isTorchLevelAvailable {
    return cameraMethodHandler.isTorchLevelAvailable(cameraPosition: camera.position.toString());
  }

  Future<void> switchCameraToDesiredState(FrameSourceState desiredState) {
    return cameraMethodHandler.switchCameraToDesiredState(stateJson: desiredState.toString());
  }

  void _notifyCameraListeners(FrameSourceState state) {
    for (var listener in camera._frameSourceListeners) {
      listener.didChangeState(camera, state);
    }
  }

  void _notifyTorchListeners(TorchState state) {
    for (var listener in camera._torchStateListeners) {
      listener.didChangeTorchToState(state);
    }
  }

  void _notifyMacroModeListeners(MacroMode macroMode) {
    for (var listener in camera._macroModeListeners) {
      listener.didChangeMacroMode(macroMode);
    }
  }

  void _notifyZoomListeners(double oldZoomLevel, double newZoomLevel) {
    for (var listener in camera._zoomListeners) {
      listener.didChangeZoomLevel(oldZoomLevel, newZoomLevel);
    }
  }

  @override
  void dispose() {
    unsubscribeFrameSourceListener();
    unsubscribeTorchListener();
    unsubscribeMacroModeListener();
    unsubscribeZoomListener();
    super.dispose();
  }
}
