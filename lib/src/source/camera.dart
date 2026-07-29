/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:scandit_flutter_datacapture_core/src/data_capture_context.dart';
import 'package:scandit_flutter_datacapture_core/src/defaults.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/sdk_logger.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_settings.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/torch_state.dart';

class Camera implements FrameSource {
  CameraSettings? _settings;
  late CameraPosition _position;
  TorchState _desiredTorchState = TorchState.off;
  FrameSourceState _desiredState = FrameSourceState.off;
  late final _CameraController _cameraController;
  DataCaptureContext? _context;

  final List<FrameSourceListener> _frameSourceListeners = [];
  final List<TorchListener> _torchStateListeners = [];

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
    }
  }

  void removeTorchListener(TorchListener listener) {
    _torchStateListeners.remove(listener);
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
    };
    if (_settings != null) {
      json['settings'] = _settings?.toMap();
    }
    return json;
  }
}

class _CameraController extends BaseController {
  final Camera camera;

  final EventChannel _cameraEventChannel = const EventChannel(FunctionNames.eventsChannelName);
  StreamSubscription? _stateChangeSubscription;

  _CameraController(this.camera) : super(FunctionNames.methodsChannelName) {
    subscribeFrameSourceListener();
  }

  void subscribeFrameSourceListener() {
    if (_stateChangeSubscription != null) return;
    _stateChangeSubscription = _cameraEventChannel.receiveBroadcastStream().listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;

      if (eventName == FunctionNames.eventFrameSourceStateChanged) {
        var state = FrameSourceState.fromJSON(jsonDecode(event)['state'] as String);
        var cameraPosition = CameraPosition.fromJSON(jsonDecode(event)['cameraPosition'] as String);
        if (cameraPosition != camera.position) {
          // This event is for the other camera most probably, so we can ignore it
          return;
        }
        camera._cameraState = state;
        if (camera._isActiveCamera) {
          _notifyCameraListeners(state);
        }
      }

      if (eventName == FunctionNames.eventTorchStateChanged) {
        var state = TorchState.fromJSON(jsonDecode(event)['state'] as String);
        if (camera._isActiveCamera) {
          camera._desiredTorchState = state;
          if (camera._isActiveCamera) {
            _notifyTorchListeners(state);
          }
        }
      }
    });
  }

  void unsubscribeFrameSourceListener() {
    _stateChangeSubscription?.cancel();
    _stateChangeSubscription = null;
  }

  Future<bool> get isTorchAvailable async {
    var isTorchAvailableReturn =
        await methodChannel.invokeMethod<bool>(FunctionNames.isTorchAvailableMethodName, camera.position.toString());

    return isTorchAvailableReturn ?? false;
  }

  Future<void> switchCameraToDesiredState(FrameSourceState desiredState) {
    return methodChannel
        .invokeMethod(FunctionNames.switchCameraToDesiredState, desiredState.toString())
        .onError(onError);
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

  @override
  void dispose() {
    unsubscribeFrameSourceListener();
    super.dispose();
  }
}
