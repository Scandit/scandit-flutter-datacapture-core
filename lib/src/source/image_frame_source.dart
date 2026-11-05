import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/src/data_capture_context.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/schema_types.dart' show buildImageFrameSource;
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';

import 'frame_source.dart';

/// To emit the frame set this object as the `frame source` for the [DataCaptureContext] and turn it on by changing the desired state to [FrameSourceState.on].
///
/// This frame source will turn off automatically after the frame is emitted.
///
/// The mode settings must use [ScanIntention.manual]. [ScanIntention.smart] has to observe a barcode across several frames before it returns it, which a frame source that emits one image and then turns off cannot provide.
///
/// This frame source emits a *single* image and turns off again. To feed a continuous stream of frames from a camera your application owns, use [SequenceFrameSource] instead — see Sequence Frame Source.Creating an [ImageFrameSource] per frame and setting it on the [DataCaptureContext] every time is orders of magnitude slower on this platform: each image has to be encoded to be passed over the bridge, and setting a frame source re-serializes the whole context.
///
/// Added in version 6.15.0
class ImageFrameSource extends FrameSource {
  FrameSourceState _desiredState = FrameSourceState.off;
  final CameraPosition _position = CameraPosition.worldFacing;
  late _ImageFrameSourceController _controller;
  final List<FrameSourceListener> _frameSourceListeners = [];
  final String _base64EncodedImage;
  final String _id = UniqueKey().toString();

  DataCaptureContext? _context;

  ImageFrameSource._(this._base64EncodedImage) {
    _controller = _ImageFrameSourceController(this);
  }

  /// Added in version 6.15.0
  static ImageFrameSource create(Uint8List bytes) {
    return ImageFrameSource._(base64Encode(bytes));
  }

  /// Implemented from [FrameSource]. See [FrameSource.addListener].
  ///
  /// Added in version 6.15.0
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

  /// Implemented from [FrameSource]. See [FrameSource.currentState].
  ///
  /// Added in version 6.15.0
  @override
  Future<FrameSourceState> get currentState => Future(() => _desiredState);

  /// Implemented from [FrameSource]. See [FrameSource.desiredState].
  ///
  /// Added in version 6.15.0
  @override
  FrameSourceState get desiredState => _desiredState;

  /// Implemented from [FrameSource]. See [FrameSource.removeListener].
  ///
  /// Added in version 6.15.0
  @override
  void removeListener(FrameSourceListener? listener) {
    if (listener == null) return;

    _frameSourceListeners.remove(listener);

    if (_frameSourceListeners.isEmpty) {
      _controller.unsubscribeFrameSourceListener();
    }
  }

  /// Convenience method for FrameSource.switchToDesiredState(): it is same as calling FrameSource.switchToDesiredState() with the second argument set to *null*.
  ///
  /// Added in version 6.15.0
  @override
  Future<void> switchToDesiredState(FrameSourceState state) async {
    _desiredState = state;
    if (!_isActiveCamera) return;
    await _controller.switchCameraToDesiredState(state);
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
    var json = buildImageFrameSource(
      type: 'image',
      id: _id,
      image: _base64EncodedImage,
    );
    // position/desiredState are not modeled in core/image_frame_source.json (schema gap) -
    // keep sending them as before.
    json['position'] = _position.toString();
    json['desiredState'] = _desiredState.toString();
    return json;
  }
}

class _ImageFrameSourceController extends BaseController {
  final ImageFrameSource imageFrameSource;
  late CoreMethodHandler cameraMethodHandler;

  StreamSubscription? _stateChangeSubscription;

  _ImageFrameSourceController(this.imageFrameSource) : super(FunctionNames.methodsChannelName) {
    cameraMethodHandler = CoreMethodHandler(methodChannel);
  }

  @override
  void dispose() {
    unsubscribeFrameSourceListener();
    super.dispose();
  }

  void subscribeFrameSourceListener() {
    if (_stateChangeSubscription != null) return;
    _stateChangeSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().listen((event) {
      if (event.isEvent(FunctionNames.eventFrameSourceStateChanged)) {
        var state = FrameSourceState.fromJSON(event.payload['state'] as String);
        _notifyCameraListeners(state);
      }
    });
  }

  Future<void> switchCameraToDesiredState(FrameSourceState desiredState) {
    return cameraMethodHandler.switchCameraToDesiredState(stateJson: desiredState.toString());
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
