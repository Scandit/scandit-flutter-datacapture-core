/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'common.dart';
import 'defaults.dart';
import 'frame_source.dart';
import 'function_names.dart';

enum CameraPosition { worldFacing, userFacing, unspecified }

extension CameraPositionDeserializer on CameraPosition {
  static CameraPosition cameraPositionFromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'worldFacing':
        return CameraPosition.worldFacing;
      case 'userFacing':
        return CameraPosition.userFacing;
      case 'unspecified':
        return CameraPosition.unspecified;
      default:
        throw Exception("Missing CameraPosition for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case CameraPosition.worldFacing:
        return 'worldFacing';
      case CameraPosition.userFacing:
        return 'userFacing';
      case CameraPosition.unspecified:
        return 'unspecified';
      default:
        throw Exception("Missing Json Value for '$this' camera position");
    }
  }
}

enum TorchState { on, off, auto }

extension TorchStateDeserializer on TorchState {
  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case TorchState.on:
        return 'on';
      case TorchState.off:
        return 'off';
      case TorchState.auto:
        return 'auto';
      default:
        throw Exception("Missing Json Value for '$this' torch state");
    }
  }

  static TorchState fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'on':
        return TorchState.on;
      case 'off':
        return TorchState.off;
      case 'auto':
        return TorchState.auto;
      default:
        throw Exception("Missing TorchState for '$jsonValue'");
    }
  }
}

enum VideoResolution { auto, hd, fullHd, uhd4k }

extension VideoResolutionDeserializer on VideoResolution {
  static VideoResolution videoResolutionFromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'auto':
        return VideoResolution.auto;
      case 'hd':
        return VideoResolution.hd;
      case 'fullHd':
        return VideoResolution.fullHd;
      case 'uhd4k':
        return VideoResolution.uhd4k;
      default:
        throw Exception("Missing VideoResolution for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case VideoResolution.auto:
        return 'auto';
      case VideoResolution.hd:
        return 'hd';
      case VideoResolution.fullHd:
        return 'fullHd';
      case VideoResolution.uhd4k:
        return 'uhd4k';
      default:
        throw Exception("Missing Json Value for '$this' video resolution");
    }
  }
}

enum FocusRange { full, near, far }

extension FocusRangeDeserializer on FocusRange {
  static FocusRange focusRangeFromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'full':
        return FocusRange.full;
      case 'near':
        return FocusRange.near;
      case 'far':
        return FocusRange.far;
      default:
        throw Exception("Missing FocusRange for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case FocusRange.full:
        return 'full';
      case FocusRange.near:
        return 'near';
      case FocusRange.far:
        return 'far';
      default:
        throw Exception("Missing Json value for '$this' focus range");
    }
  }
}

enum FocusGestureStrategy { none, manual, manualUntilCapture, autoOnLocation }

extension FocusGestureStrategyDeserializer on FocusGestureStrategy {
  static FocusGestureStrategy focusGestureStrategyFromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'none':
        return FocusGestureStrategy.none;
      case 'manual':
        return FocusGestureStrategy.manual;
      case 'manualUntilCapture':
        return FocusGestureStrategy.manualUntilCapture;
      case 'autoOnLocation':
        return FocusGestureStrategy.autoOnLocation;
      default:
        throw Exception("Missing FocusGestureStrategy for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case FocusGestureStrategy.none:
        return 'none';
      case FocusGestureStrategy.manual:
        return 'manual';
      case FocusGestureStrategy.manualUntilCapture:
        return 'manualUntilCapture';
      case FocusGestureStrategy.autoOnLocation:
        return 'autoOnLocation';
      default:
        throw Exception("Missing Json value for '$this' focus gesture strategy");
    }
  }
}

class CameraSettings implements Serializable {
  final Map<String, dynamic> _cameraSettingsProperties = <String, dynamic>{};
  final Map<String, dynamic> _cameraFocusHiddenProperties = <String, dynamic>{};
  final _focusHiddenProperties = ['manualLensPosition', 'focusStrategy'];

  VideoResolution preferredResolution;
  double zoomFactor;
  FocusRange focusRange;
  FocusGestureStrategy focusGestureStrategy;
  double zoomGestureZoomFactor;
  bool shouldPreferSmoothAutoFocus;

  void setProperty<T>(String name, T value) {
    if (_focusHiddenProperties.contains(name)) {
      _cameraFocusHiddenProperties[name] = value;
      return;
    }
    _cameraSettingsProperties[name] = value;
  }

  T getProperty<T>(String name) {
    if (_focusHiddenProperties.contains(name)) {
      return _cameraFocusHiddenProperties[name] as T;
    }
    return _cameraSettingsProperties[name] as T;
  }

  CameraSettings(
      this.preferredResolution, this.zoomFactor, this.focusRange, this.focusGestureStrategy, this.zoomGestureZoomFactor,
      {required this.shouldPreferSmoothAutoFocus});

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> json;
    json = {
      'preferredResolution': preferredResolution.jsonValue,
      'zoomFactor': zoomFactor,
      'focusRange': focusRange.jsonValue,
      'focus': {
        'range': focusRange.jsonValue,
        'focusGestureStrategy': focusGestureStrategy.jsonValue,
        'shouldPreferSmoothAutoFocus': shouldPreferSmoothAutoFocus
      },
      'zoomGestureZoomFactor': zoomGestureZoomFactor
    };
    _cameraFocusHiddenProperties.forEach((key, value) {
      json['focus'][key] = value;
    });
    if (_cameraSettingsProperties.isNotEmpty) {
      json.addAll(_cameraSettingsProperties);
    }
    return json;
  }
}

class Camera extends FrameSource {
  CameraSettings? _settings;
  late CameraPosition _position;
  TorchState _desiredTorchState = TorchState.off;
  FrameSourceState _desiredState = FrameSourceState.off;
  late _CameraController _cameraController;
  final List<FrameSourceListener> _frameSourceListeners = [];
  final List<TorchListener> _torchStateListeners = [];

  CameraPosition get position => _position;

  static Camera? get defaultCamera => _defaultCamera();

  static Camera? _defaultCamera() {
    var defaultPosition = Defaults.cameraDefaults.defaultPosition;
    return defaultPosition == null ? null : Camera.atPosition(defaultPosition);
  }

  @override
  Future<FrameSourceState> get currentState => _cameraController.getCurrentState();

  @override
  FrameSourceState get desiredState => _desiredState;

  Camera._() {
    _cameraController = _CameraController(this, Defaults.channel);
  }

  static Camera? atPosition(CameraPosition cameraPosition) {
    if (Defaults.cameraDefaults.availablePositions.contains(cameraPosition) == false) {
      return null;
    }
    var camera = Camera._();
    camera._position = cameraPosition;
    return camera;
  }

  TorchState get desiredTorchState => _desiredTorchState;

  set desiredTorchState(TorchState newValue) {
    _desiredTorchState = newValue;
    _onChange();
  }

  @override
  Future<void> switchToDesiredState(FrameSourceState state) {
    _desiredState = state;
    return _onChange();
  }

  Future<void> applySettings(CameraSettings settings) {
    _settings = settings;
    return _onChange();
  }

  Future<bool> get isTorchAvailable => _cameraController.isTorchAvailable;

  @override
  void addListener(FrameSourceListener? listener) {
    if (listener == null) return;

    if (_frameSourceListeners.isEmpty) {
      _cameraController.subscribeFrameSourceListener();
    }

    if (!_frameSourceListeners.contains(listener)) {
      _frameSourceListeners.add(listener);
    }
  }

  @override
  void removeListener(FrameSourceListener? listener) {
    if (listener == null) return;

    _frameSourceListeners.remove(listener);

    if (_frameSourceListeners.isEmpty) {
      _cameraController.unsubscribeFrameSourceListener();
    }
  }

  void addTorchListener(TorchListener listener) {
    if (_torchStateListeners.isEmpty) {
      _cameraController.subscribeTorchListener();
    }

    if (!_torchStateListeners.contains(listener)) {
      _torchStateListeners.add(listener);
    }
  }

  void removeTorchListener(TorchListener listener) {
    _torchStateListeners.remove(listener);

    if (_torchStateListeners.isEmpty) {
      _cameraController.unsubscribTorchListener();
    }
  }

  Future<void> _onChange() {
    return context?.update() ?? Future<void>.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'camera',
      'position': _position.jsonValue,
      'desiredTorchState': _desiredTorchState.jsonValue,
      'desiredState': _desiredState.jsonValue
    };
    if (_settings != null) {
      json['settings'] = _settings?.toMap();
    }
    return json;
  }
}

class _CameraController {
  final Camera camera;
  final MethodChannel methodChannel;

  final EventChannel _stateChangeEventChannel =
      const EventChannel('com.scandit.datacapture.core.event/camera#didChangeState');
  StreamSubscription? _stateChangeSubscription;

  final EventChannel _torchStateChangeEventChannel =
      const EventChannel('com.scandit.datacapture.core.event/camera#didChangeTorchState');

  StreamSubscription? _torchStateChangeSubscription;

  _CameraController(this.camera, this.methodChannel);

  void subscribeFrameSourceListener() {
    if (_stateChangeSubscription != null) return;
    _stateChangeSubscription = _stateChangeEventChannel.receiveBroadcastStream().listen((event) {
      var state = FrameSourceStateDeserializer.fromJSON(jsonDecode(event)['state'] as String);
      _notifyCameraListeners(state);
    });
  }

  void unsubscribeFrameSourceListener() {
    _stateChangeSubscription?.cancel();
    _stateChangeSubscription = null;
  }

  void subscribeTorchListener() {
    if (_torchStateChangeSubscription != null) return;
    _torchStateChangeSubscription = _torchStateChangeEventChannel.receiveBroadcastStream().listen((event) {
      var state = TorchStateDeserializer.fromJSON(jsonDecode(event)['state'] as String);
      _notifyTorchListeners(state);
    });
  }

  void unsubscribTorchListener() {
    _torchStateChangeSubscription?.cancel();
    _torchStateChangeSubscription = null;
  }

  Future<FrameSourceState> getCurrentState() {
    return methodChannel
        .invokeMethod(FunctionNames.getCameraStateMethodName, camera.position.jsonValue)
        .then((value) => FrameSourceStateDeserializer.fromJSON(value as String));
  }

  Future<bool> get isTorchAvailable async {
    var isTorchAvailableReturn =
        await methodChannel.invokeMethod<bool>(FunctionNames.isTorchAvailableMethodName, camera.position.jsonValue);

    return isTorchAvailableReturn ?? false;
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
}
