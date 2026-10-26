/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:scandit_flutter_datacapture_core/src/data_capture_context.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';

import 'frame_source.dart';

/// A frame source that processes frames fed to it via [SequenceFrameSource.addFrame], in the
/// order they are added. Use it when the camera is not handled by the SDK (e.g. when another
/// framework owns the camera).
class SequenceFrameSource extends FrameSource {
  // The native handlers key their instance-reuse and addFrame routing on this id, so it must
  // be unique across instances — a timestamp alone can collide within the same millisecond.
  static int _nextInstanceId = 0;

  final String _id = '${DateTime.now().millisecondsSinceEpoch}-${_nextInstanceId++}';
  final CameraPosition _position;
  final double _lensPosition;
  FrameSourceState _desiredState = FrameSourceState.off;
  late _SequenceFrameSourceController _controller;
  final List<FrameSourceListener> _frameSourceListeners = [];

  DataCaptureContext? _context;

  SequenceFrameSource._(this._position, this._lensPosition) {
    _controller = _SequenceFrameSourceController(this);
  }

  /// Creates a sequence frame source for the given camera position. On iOS the lens position
  /// (0.0-1.0) sets the capture device lens position; on Android it is ignored.
  static SequenceFrameSource create(CameraPosition position, {double? lensPosition}) {
    return SequenceFrameSource._(position, lensPosition ?? 1);
  }

  @override
  FrameSourceState get desiredState => _desiredState;

  @override
  Future<FrameSourceState> get currentState async {
    if (!_hasContext) return _desiredState;
    final result = await _controller.getCurrentState(_id);
    return FrameSourceState.fromJSON(result);
  }

  @override
  DataCaptureContext? get context => _context;

  @override
  set context(DataCaptureContext? context) {
    _context = context;
  }

  bool get _hasContext => _context != null;

  @override
  Future<void> switchToDesiredState(FrameSourceState state) async {
    _desiredState = state;
    if (!_hasContext) return;
    await _controller.switchCameraToDesiredState(state);
  }

  /// Adds a frame with the given width and height. The frame data must be the raw NV21 bytes
  /// of the frame. If this frame source is on and connected to a data capture context, this is
  /// the next frame that will be processed.
  Future<void> addFrame(int width, int height, Uint8List frameData) {
    return _controller.addFrame(_id, width, height, base64Encode(frameData));
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
  void removeListener(FrameSourceListener? listener) {
    if (listener == null) return;

    _frameSourceListeners.remove(listener);

    if (_frameSourceListeners.isEmpty) {
      _controller.unsubscribeFrameSourceListener();
    }
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'sequence',
      'id': _id,
      'position': _position.toString(),
      'desiredState': _desiredState.toString(),
      'lensPosition': _lensPosition
    };
    return json;
  }
}

class _SequenceFrameSourceController extends BaseController {
  final SequenceFrameSource sequenceFrameSource;
  late CoreMethodHandler coreMethodHandler;

  StreamSubscription? _stateChangeSubscription;
  bool _listenerWanted = false;

  _SequenceFrameSourceController(this.sequenceFrameSource) : super(FunctionNames.methodsChannelName) {
    coreMethodHandler = CoreMethodHandler(methodChannel);
  }

  @override
  void dispose() {
    unsubscribeFrameSourceListener();
    super.dispose();
  }

  void subscribeFrameSourceListener() {
    // The native emitter only forwards FrameSourceListener events once a bridge-level
    // listener is registered (see FrameworksFrameSourceListener.enable()).
    _listenerWanted = true;
    coreMethodHandler.registerFrameSourceListener().then((value) {
      if (!_listenerWanted) return;
      _setupStateChangeSubscription();
    });
  }

  void _setupStateChangeSubscription() {
    if (_stateChangeSubscription != null) return;
    _stateChangeSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventFrameSourceStateChanged)) {
        if (event.payload['cameraPosition'] != null) {
          // Camera state changes carry a position; this frame source only handles
          // non-camera state events.
          return;
        }
        var state = FrameSourceState.fromJSON(event.payload['state'] as String);
        _notifyListeners(state);
      }
    });
  }

  void unsubscribeFrameSourceListener() {
    _listenerWanted = false;
    var subscription = _stateChangeSubscription;
    _stateChangeSubscription = null;
    subscription?.cancel();
    // Deliberately no bridge-level unregisterFrameSourceListener() here: the native
    // FrameworksFrameSourceListener enabled flag is shared (not refcounted) and
    // _CameraController depends on it for camera state events. Mirrors
    // _ImageFrameSourceController, which also only cancels the Dart subscription.
  }

  Future<void> switchCameraToDesiredState(FrameSourceState desiredState) {
    return coreMethodHandler.switchCameraToDesiredState(stateJson: desiredState.toString());
  }

  Future<void> addFrame(String frameSourceId, int width, int height, String frameData) {
    return coreMethodHandler.addFrameToSequenceFrameSource(
      frameSourceId: frameSourceId,
      width: width,
      height: height,
      frameData: frameData,
    );
  }

  Future<String> getCurrentState(String frameSourceId) async {
    // Do not use the generated getSequenceFrameSourceState wrapper here: the native side
    // returns the bare state string (e.g. 'on'), not a JSON object, and the generated
    // wrapper jsonDecodes the result into a Map.
    final result = await coreMethodHandler.executeCore(
      'CoreModule',
      'getSequenceFrameSourceState',
      {'frameSourceId': frameSourceId},
    );
    return result as String;
  }

  void _notifyListeners(FrameSourceState state) {
    // Snapshot: a listener may remove itself from within didChangeState.
    for (var listener in List.of(sequenceFrameSource._frameSourceListeners)) {
      listener.didChangeState(sequenceFrameSource, state);
    }
  }
}
