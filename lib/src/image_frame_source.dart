import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';

import 'camera.dart';
import 'defaults.dart';
import 'frame_source.dart';

class ImageFrameSource extends FrameSource {
  FrameSourceState _desiredState = FrameSourceState.off;
  final CameraPosition _position = CameraPosition.worldFacing;
  late _ImageFrameSourceController _controller;
  final List<FrameSourceListener> _frameSourceListeners = [];
  final String _base64EncodedImage;
  final String _id = UniqueKey().toString();

  ImageFrameSource._(this._base64EncodedImage) {
    _controller = _ImageFrameSourceController(this, Defaults.channel);
  }

  static ImageFrameSource create(Uint8List bytes) {
    return ImageFrameSource._(base64Encode(bytes));
  }

  @override
  void addListener(FrameSourceListener? listener) {
    if (listener == null) return;

    if (_frameSourceListeners.isEmpty) {
      _controller.subscribeFrameSourceListener();
    }

    if (!_frameSourceListeners.contains(listener)) {
      _frameSourceListeners.add(listener);
    }
  }

  @override
  Future<FrameSourceState> get currentState => Future(() => _desiredState);

  @override
  FrameSourceState get desiredState => _desiredState;

  @override
  void removeListener(FrameSourceListener? listener) {
    if (listener == null) return;

    _frameSourceListeners.remove(listener);

    if (_frameSourceListeners.isEmpty) {
      _controller.unsubscribeFrameSourceListener();
    }
  }

  @override
  Future<void> switchToDesiredState(FrameSourceState state) {
    _desiredState = state;
    return _controller.switchCameraToDesiredState(state);
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'image',
      'id': _id,
      'position': _position.toString(),
      'desiredState': _desiredState.toString(),
      'image': _base64EncodedImage
    };
    return json;
  }
}

class _ImageFrameSourceController {
  final ImageFrameSource imageFrameSource;
  final MethodChannel methodChannel;

  final EventChannel _stateChangeEventChannel = const EventChannel(FunctionNames.eventsChannelName);
  StreamSubscription? _stateChangeSubscription;

  _ImageFrameSourceController(this.imageFrameSource, this.methodChannel);

  void subscribeFrameSourceListener() {
    if (_stateChangeSubscription != null) return;
    _stateChangeSubscription = _stateChangeEventChannel.receiveBroadcastStream().listen((event) {
      var eventJSON = jsonDecode(event);
      var eventName = eventJSON['event'] as String;
      if (eventName == FunctionNames.eventFrameSourceStateChanged) {
        var state = FrameSourceStateDeserializer.fromJSON(jsonDecode(event)['state'] as String);
        _notifyCameraListeners(state);
      }
    });
  }

  Future<void> switchCameraToDesiredState(FrameSourceState desiredState) {
    return methodChannel.invokeMethod(FunctionNames.switchCameraToDesiredState, desiredState.toString());
  }

  void unsubscribeFrameSourceListener() {
    _stateChangeSubscription?.cancel();
    _stateChangeSubscription = null;
  }

  void _notifyCameraListeners(FrameSourceState state) {
    for (var listener in imageFrameSource._frameSourceListeners) {
      listener.didChangeState(imageFrameSource, state);
    }
  }
}
