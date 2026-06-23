/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
import 'dart:async';

import 'package:scandit_flutter_datacapture_core/src/data_capture_context.dart';
import 'package:scandit_flutter_datacapture_core/src/defaults.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/flutter_event.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/helpers.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/sdk_logger.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_settings.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/torch_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/macro_mode.dart';

class Camera implements FrameSource {
  CameraSettings? _settings;
  late CameraPosition _position;
  TorchState _desiredTorchState = TorchState.off;
  FrameSourceState _desiredState = FrameSourceState.off;
  late final _CameraController _cameraController;
  DataCaptureContext? _context;

  final List<FrameSourceListener> _frameSourceListeners = [];
  final List<TorchListener> _torchStateListeners = [];
  final List<MacroModeListener> _macroModeListeners = [];
  final List<ZoomListener> _zoomListeners = [];

  CameraPosition get position => _position;

  static final Map<CameraPosition, Camera> _cameraInstances = {};

  FrameSourceState _cameraState = FrameSourceState.off;

  static Camera? get defaultCamera {
    final defaultPosition = Defaults.cameraDefaults.defaultPosition;
    if (defaultPosition == null) return null;
    return atPosition(defaultPosition);
  }

  @override
  Future<FrameSourceState> get currentState => Future(() => _cameraState);

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

  static Camera? atPosition(CameraPosition cameraPosition) {
    if (Defaults.cameraDefaults.availablePositions.contains(cameraPosition) == false) {
      return null;
    }

    return _cameraInstances.putIfAbsent(cameraPosition, () => Camera._(position: cameraPosition));
  }

  static Future<bool> get isMacroModeAvailable async {
    final handler = getCoreMethodHandler();
    final result = await handler.isMacroModeAvailable();
    return result;
  }

  TorchState get desiredTorchState => _desiredTorchState;

  set desiredTorchState(TorchState newValue) {
    _desiredTorchState = newValue;
    if (!_isActiveCamera) {
      SdkLogger.warning('Camera', 'desiredTorchState', 'The current camera is not added to the DataCaptureContext.',
          'Add camera to the DataCaptureContext first.');
      return;
    }
    _onChange();
  }

  @override
  Future<void> switchToDesiredState(FrameSourceState state) async {
    _desiredState = state;
    if (!_isActiveCamera) {
      SdkLogger.warning('Camera', 'switchToDesiredState', 'The current camera is not added to the DataCaptureContext.',
          'Add camera to the DataCaptureContext first.');
      return;
    }
    await _cameraController.switchCameraToDesiredState(state);
  }

  Future<void> applySettings(CameraSettings settings) async {
    _settings = settings;
    if (!_isActiveCamera) {
      return;
    }
    await _onChange();
  }

  Future<bool> get isTorchAvailable => _cameraController.isTorchAvailable;

  @override
  void addListener(FrameSourceListener? listener) {
    if (listener == null) return;

    if (!_frameSourceListeners.contains(listener)) {
      _frameSourceListeners.add(listener);
    }
  }

  @override
  void removeListener(FrameSourceListener? listener) {
    if (listener == null) return;

    _frameSourceListeners.remove(listener);
  }

  void addTorchListener(TorchListener listener) {
    if (!_torchStateListeners.contains(listener)) {
      _torchStateListeners.add(listener);
      if (_torchStateListeners.length == 1) {
        _cameraController.subscribeTorchListener();
      }
    }
  }

  void removeTorchListener(TorchListener listener) {
    _torchStateListeners.remove(listener);
    if (_torchStateListeners.isEmpty) {
      _cameraController.unsubscribeTorchListener();
    }
  }

  void addMacroModeListener(MacroModeListener listener) {
    if (!_macroModeListeners.contains(listener)) {
      _macroModeListeners.add(listener);
      if (_macroModeListeners.length == 1) {
        _cameraController.subscribeMacroModeListener();
      }
    }
  }

  void removeMacroModeListener(MacroModeListener listener) {
    _macroModeListeners.remove(listener);
    if (_macroModeListeners.isEmpty) {
      _cameraController.unsubscribeMacroModeListener();
    }
  }

  void addZoomListener(ZoomListener listener) {
    if (!_zoomListeners.contains(listener)) {
      _zoomListeners.add(listener);
      if (_zoomListeners.length == 1) {
        _cameraController.subscribeZoomListener();
      }
    }
  }

  void removeZoomListener(ZoomListener listener) {
    _zoomListeners.remove(listener);
    if (_zoomListeners.isEmpty) {
      _cameraController.unsubscribeZoomListener();
    }
  }

  Future<void> _onChange() async {
    await context?.update();
  }

  @override
  DataCaptureContext? get context => _context;

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
        var state = FrameSourceState.fromJSON(event.payload['state'] as String);
        var cameraPosition = CameraPosition.fromJSON(event.payload['cameraPosition'] as String);
        if (cameraPosition != camera.position) {
          // This event is for the other camera most probably, so we can ignore it
          return;
        }
        camera._cameraState = state;
        if (camera._isActiveCamera) {
          _notifyCameraListeners(state);
        }
      }
    });
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
    var state = TorchState.fromJSON(event.payload['state'] as String);
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
    var macroMode = MacroMode.fromJSON(event.payload['macroMode'] as String);
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
    final oldZoomLevel = (event.payload['oldZoomLevel'] as num).toDouble();
    final newZoomLevel = (event.payload['newZoomLevel'] as num).toDouble();
    if (camera._isActiveCamera) {
      _notifyZoomListeners(oldZoomLevel, newZoomLevel);
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
