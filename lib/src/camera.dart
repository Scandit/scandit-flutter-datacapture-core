/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'common.dart';
import 'data_capture_context.dart';
import 'defaults.dart';
import 'frame_source.dart';
import 'function_names.dart';

enum CameraPosition {
  worldFacing('worldFacing'),
  userFacing('userFacing'),
  unspecified('unspecified');

  const CameraPosition(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension CameraPositionDeserializer on CameraPosition {
  static CameraPosition cameraPositionFromJSON(String jsonValue) {
    return CameraPosition.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum TorchState {
  on('on'),
  off('off'),
  auto('auto');

  const TorchState(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension TorchStateDeserializer on TorchState {
  static TorchState fromJSON(String jsonValue) {
    return TorchState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum VideoResolution {
  auto('auto'),
  hd('hd'),
  fullHd('fullHd'),
  uhd4k('uhd4k');

  const VideoResolution(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension VideoResolutionDeserializer on VideoResolution {
  static VideoResolution videoResolutionFromJSON(String jsonValue) {
    return VideoResolution.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum FocusRange {
  full('full'),
  near('near'),
  far('far');

  const FocusRange(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension FocusRangeDeserializer on FocusRange {
  static FocusRange focusRangeFromJSON(String jsonValue) {
    return FocusRange.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum FocusGestureStrategy {
  none('none'),
  manual('manual'),
  manualUntilCapture('manualUntilCapture'),
  autoOnLocation('autoOnLocation');

  const FocusGestureStrategy(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension FocusGestureStrategyDeserializer on FocusGestureStrategy {
  static FocusGestureStrategy focusGestureStrategyFromJSON(String jsonValue) {
    return FocusGestureStrategy.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class CameraSettings implements Serializable {
  final Map<String, dynamic> _cameraSettingsProperties = <String, dynamic>{};

  final Map<String, dynamic> _cameraFocusHiddenProperties = <String, dynamic>{};
  final _focusHiddenProperties = [
    'range',
    'manualLensPosition',
    'shouldPreferSmoothAutoFocus',
    'focusStrategy',
    'focusGestureStrategy'
  ];

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
      {required this.shouldPreferSmoothAutoFocus, Map<String, dynamic> properties = const <String, dynamic>{}}) {
    for (var hiddenProperty in properties.entries) {
      setProperty(hiddenProperty.key, hiddenProperty.value);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> json;
    json = {
      'preferredResolution': preferredResolution.toString(),
      'zoomFactor': zoomFactor,
      'focusRange': focusRange.toString(),
      'focus': {
        'range': focusRange.toString(),
        'focusGestureStrategy': focusGestureStrategy.toString(),
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

class Camera with PrivateCamera implements FrameSource {
  CameraSettings? _settings;
  late CameraPosition _position;
  TorchState _desiredTorchState = TorchState.off;
  FrameSourceState _desiredState = FrameSourceState.off;

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
    return _cameraController.switchCameraToDesiredState(state);
  }

  Future<void> applySettings(CameraSettings settings) {
    _settings = settings;
    return _onChange();
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

  Future<void> _onChange() {
    return context?.update() ?? Future<void>.value();
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'camera',
      'position': _position.toString(),
      'desiredTorchState': _desiredTorchState.toString()
    };
    if (_settings != null) {
      json['settings'] = _settings?.toMap();
    }
    return json;
  }
}

mixin PrivateCamera implements FrameSource {
  late _CameraController _cameraController;
  DataCaptureContext? _context;

  @override
  DataCaptureContext? get context => _context;

  @override
  set context(DataCaptureContext? context) {
    _context = context;
    if (context != null) {
      _cameraController.subscribeFrameSourceListener();
    } else {
      _cameraController.unsubscribeFrameSourceListener();
    }
  }
}

class _CameraController {
  final Camera camera;
  final MethodChannel methodChannel;

  final EventChannel _cameraEventChannel = const EventChannel(FunctionNames.eventsChannelName);
  StreamSubscription? _stateChangeSubscription;

  _CameraController(this.camera, this.methodChannel);

  void subscribeFrameSourceListener() {
    if (_stateChangeSubscription != null) return;
    _stateChangeSubscription = _cameraEventChannel.receiveBroadcastStream().listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;

      if (eventName == FunctionNames.eventFrameSourceStateChanged) {
        var state = FrameSourceStateDeserializer.fromJSON(jsonDecode(event)['state'] as String);
        _notifyCameraListeners(state);
      }

      if (eventName == FunctionNames.eventTorchStateChanged) {
        var state = TorchStateDeserializer.fromJSON(jsonDecode(event)['state'] as String);
        camera._desiredTorchState = state;
        _notifyTorchListeners(state);
      }
    });
  }

  void unsubscribeFrameSourceListener() {
    _stateChangeSubscription?.cancel();
    _stateChangeSubscription = null;
  }

  Future<FrameSourceState> getCurrentState() {
    return methodChannel
        .invokeMethod(FunctionNames.getCameraStateMethodName, camera.position.toString())
        .then((value) => FrameSourceStateDeserializer.fromJSON(value as String));
  }

  Future<bool> get isTorchAvailable async {
    var isTorchAvailableReturn =
        await methodChannel.invokeMethod<bool>(FunctionNames.isTorchAvailableMethodName, camera.position.toString());

    return isTorchAvailableReturn ?? false;
  }

  Future<void> switchCameraToDesiredState(FrameSourceState desiredState) {
    return methodChannel.invokeMethod(FunctionNames.switchCameraToDesiredState, desiredState.toString());
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
