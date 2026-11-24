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
import 'package:scandit_flutter_datacapture_core/src/internal/generated/schema_types.dart'
    show buildSequenceFrameSource;
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';

import 'frame_source.dart';

/// A frame source that processes frames fed to it via [SequenceFrameSource.addFrame], in the
/// order they are added. Use it when the camera is not handled by the SDK (e.g. when another
/// framework owns the camera).
///
/// Emits frames added via [SequenceFrameSource.addFrame].
///
/// Use this class when your application, and not the Scandit Data Capture SDK, owns the camera.
///
/// That is the case when the frames come from a framework that runs its own capture session, such as ARKit on iOS or ARCore on Android, or from a camera plugin your application configures itself.
///
/// Register an instance of this class as the frame source via [DataCaptureContext.frameSource], switch it to [FrameSourceState.on], and then add the frames coming from the camera via [SequenceFrameSource.addFrame]. The frame source never opens, selects or configures a camera itself — it only forwards the frames you push into it.
///
/// Frames reach the Scandit Data Capture SDK only while [FrameSource.currentState] is [FrameSourceState.on] and the frame source is attached to a [DataCaptureContext], which is why the state has to be switched explicitly, just as it is for [Camera]. A frame added before both conditions are true stays in a short internal queue and is emitted as soon as they are. If the queue fills up, the oldest frames are dropped first. Switching the frame source [FrameSourceState.off] again stops processing without discarding that queue.
///
/// Only one frame is in flight at a time — the next queued frame is emitted once the [DataCaptureContext] has finished with the previous one. Pushing frames faster than they can be processed therefore drops frames rather than building up latency.
///
/// Register the frame source and switch it on **once**, outside of your frame loop, and then call [SequenceFrameSource.addFrame] for each frame. Do not create a frame source per frame, and do not set one on the [DataCaptureContext] from inside the frame loop. In particular, do not feed a continuous camera stream through [ImageFrameSource] — it is meant for single images and turns off after each one.On this platform both mistakes are expensive rather than merely wasteful: setting a frame source re-serializes the whole [DataCaptureContext], and [ImageFrameSource] encodes every image it is given to pass it over the bridge. Measured on a Flutter sample at 720p, the per-frame variant cost 520 ms per frame against 21 ms for the loop below.
///
/// Set up the frame source once, for example in your state’s `initState`:
///
/// ```dart
/// final frameSource = SequenceFrameSource.create(CameraPosition.worldFacing);
/// await context.setFrameSource(frameSource);
/// await frameSource.switchToDesiredState(FrameSourceState.on);
/// ```
///
/// Then, for every frame delivered by your camera, call [SequenceFrameSource.addFrame] with the raw NV21 bytes:
///
/// ```dart
/// await frameSource.addFrame(image.width, image.height, nv21Bytes);
/// ```
///
/// The `camera` plugin delivers `yuv420` frames whose planes are padded: each row is `bytesPerRow` bytes long rather than `width` bytes, and the chroma planes may be interleaved with a `bytesPerPixel` stride. [SequenceFrameSource.addFrame] expects tightly packed NV21 — the full-resolution Y plane followed by interleaved V/U samples at half resolution — so the padding has to be removed and the chroma planes interleaved first:
///
/// ```dart
/// Uint8List toNv21(CameraImage image) {
///   final width = image.width;
///   final height = image.height;
///   // Chroma dimensions round up, so odd frame sizes are handled correctly.
///   final chromaWidth = (width + 1) ~/ 2;
///   final chromaHeight = (height + 1) ~/ 2;
///   final nv21 = Uint8List(width * height + chromaWidth * chromaHeight * 2);
///
///   // Y plane: copy row by row, dropping the row padding.
///   final y = image.planes[0];
///   var offset = 0;
///   for (var row = 0; row < height; row++) {
///     nv21.setRange(offset, offset + width, y.bytes, row * y.bytesPerRow);
///     offset += width;
///   }
///
///   // Chroma planes: NV21 expects V and U interleaved, V first.
///   final u = image.planes[1];
///   final v = image.planes[2];
///   final uPixelStride = u.bytesPerPixel ?? 1;
///   final vPixelStride = v.bytesPerPixel ?? 1;
///   for (var row = 0; row < chromaHeight; row++) {
///     var uIndex = row * u.bytesPerRow;
///     var vIndex = row * v.bytesPerRow;
///     for (var column = 0; column < chromaWidth; column++) {
///       nv21[offset++] = v.bytes[vIndex];
///       nv21[offset++] = u.bytes[uIndex];
///       uIndex += uPixelStride;
///       vIndex += vPixelStride;
///     }
///   }
///
///   return nv21;
/// }
/// ```
///
/// Configure your camera controller with `ImageFormatGroup.yuv420` so that the frames arrive in this layout, and skip a frame rather than queueing it if the previous [SequenceFrameSource.addFrame] call has not completed yet.
///
/// Added in version 8.6.0
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
  ///
  /// Constructs a new [SequenceFrameSource] for the given [CameraPosition]. The lens position (0.0-1.0) sets the capture device lens position on iOS and is ignored on Android.
  ///
  /// The capture device position neither selects nor opens a camera. Instead, it tells the Scandit Data Capture SDK how to interpret the frames you push: frames declared as coming from a user-facing camera are treated as mirrored. Pass the position of the camera your application is actually reading from.
  ///
  /// Added in version 8.6.0
  static SequenceFrameSource create(CameraPosition position, {double? lensPosition}) {
    return SequenceFrameSource._(position, lensPosition ?? 1);
  }

  /// Implemented from [FrameSource]. See [FrameSource.desiredState].
  ///
  /// Added in version 8.6.0
  @override
  FrameSourceState get desiredState => _desiredState;

  /// Implemented from [FrameSource]. See [FrameSource.currentState].
  ///
  /// Added in version 8.6.0
  @override
  Future<FrameSourceState> get currentState async {
    if (!_hasContext) return _desiredState;
    final result = await _controller.getCurrentState(_id);
    return FrameSourceState.fromJSON(result);
  }

  /// Implemented from [FrameSource]. See [FrameSource.context].
  ///
  /// Added in version 8.6.0
  @override
  DataCaptureContext? get context => _context;

  /// Implemented from [FrameSource]. See [FrameSource.context].
  ///
  /// Added in version 8.6.0
  @override
  set context(DataCaptureContext? context) {
    _context = context;
  }

  bool get _hasContext => _context != null;

  /// Convenience method for FrameSource.switchToDesiredState(): it is the same as calling FrameSource.switchToDesiredState() without a completion handler.
  ///
  /// Added in version 8.6.0
  @override
  Future<void> switchToDesiredState(FrameSourceState state) async {
    _desiredState = state;
    if (!_hasContext) return;
    await _controller.switchCameraToDesiredState(state);
  }

  /// Adds a frame with the given width and height. The frame data must be the raw NV21 bytes
  /// of the frame. If this frame source is on and connected to a data capture context, this is
  /// the next frame that will be processed.
  ///
  /// Adds a frame with the given width and height. The frame data must be the raw NV21 bytes of the frame. If this frame source is [FrameSourceState.on] and connected to a [DataCaptureContext] this is the next frame that will be processed.
  ///
  /// Added in version 8.6.0
  Future<void> addFrame(int width, int height, Uint8List frameData) {
    return _controller.addFrame(_id, width, height, base64Encode(frameData));
  }

  /// Implemented from [FrameSource]. See [FrameSource.addListener].
  ///
  /// Added in version 8.6.0
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

  /// Implemented from [FrameSource]. See [FrameSource.removeListener].
  ///
  /// Added in version 8.6.0
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
    return buildSequenceFrameSource(
      type: 'sequence',
      id: _id,
      position: _position.toString(),
      desiredState: _desiredState.toString(),
      lensPosition: _lensPosition,
    );
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
