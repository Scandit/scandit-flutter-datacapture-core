import 'package:scandit_flutter_datacapture_core/src/internal/view_attachable.dart';

import 'dart:async';
import 'dart:convert';
import 'common.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';

/// Listener for observing the zoom gesture. This listener is typically used when you want to react to zoom gestures being triggered to update UI elements or similar.
///
/// Added in version 8.3.0
abstract class ZoomGestureListener {
  /// Called when a zoom in gesture is triggered.
  ///
  /// Added in version 8.3.0
  void didZoomInGesture(ZoomGesture zoomGesture);
  /// Called when a zoom out gesture is triggered.
  ///
  /// Added in version 8.3.0
  void didZoomOutGesture(ZoomGesture zoomGesture);
}

/// Common interface for all the zoom gestures.
///
/// Added in version 6.7.0
abstract class ZoomGesture extends Serializable with ViewAttachable, PrivateZoomGesture {
  /// Adds the listener to this gesture.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 8.3.0
  void addListener(ZoomGestureListener listener);
  /// Removes a previously added listener from this gesture.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 8.3.0
  void removeListener(ZoomGestureListener listener);
  /// Triggers a zoom in as if the zoom in gesture was performed.
  ///
  /// Added in version 8.3.0
  Future<void> triggerZoomIn();
  /// Triggers a zoom out as if the zoom out gesture was performed.
  ///
  /// Added in version 8.3.0
  Future<void> triggerZoomOut();
}

/// Pinch to zoom gesture.
///
/// Added in version 8.4.0
class PinchToZoom extends Serializable with ViewAttachable, PrivateZoomGesture implements ZoomGesture {
  /// Constructs a new PinchToZoom instance. The zoom levels can be changed in the [CameraSettings] via the CameraSettings.ZoomLevels property.
  ///
  /// Added in version 8.4.0
  PinchToZoom();

  /// Implemented from [ZoomGesture]. See [ZoomGesture.addListener].
  ///
  /// Added in version 8.4.0
  @override
  void addListener(ZoomGestureListener listener) {
    if (!_listeners.contains(listener)) {
      final wasEmpty = _listeners.isEmpty;
      _listeners.add(listener);
      if (wasEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  /// Implemented from [ZoomGesture]. See [ZoomGesture.removeListener].
  ///
  /// Added in version 8.4.0
  @override
  void removeListener(ZoomGestureListener listener) {
    if (_listeners.remove(listener)) {
      if (_listeners.isEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  /// Implemented from [ZoomGesture]. See [ZoomGesture.triggerZoomIn].
  ///
  /// Added in version 8.4.0
  @override
  Future<void> triggerZoomIn() async {
    await _controller?.triggerZoomIn();
  }

  /// Implemented from [ZoomGesture]. See [ZoomGesture.triggerZoomOut].
  ///
  /// Added in version 8.4.0
  @override
  Future<void> triggerZoomOut() async {
    await _controller?.triggerZoomOut();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'pinchToZoom'};
  }
}

/// Swipe to zoom gesture.
///
/// Added in version 6.7.0
class SwipeToZoom extends Serializable with ViewAttachable, PrivateZoomGesture implements ZoomGesture {
  /// Constructs a new SwipeToZoom instance. The zoom levels can be changed in the [CameraSettings] via the CameraSettings.ZoomLevels property.
  ///
  /// Added in version 6.7.0
  SwipeToZoom();

  /// Implemented from [ZoomGesture]. See [ZoomGesture.addListener].
  ///
  /// Added in version 8.3.0
  @override
  void addListener(ZoomGestureListener listener) {
    if (!_listeners.contains(listener)) {
      final wasEmpty = _listeners.isEmpty;
      _listeners.add(listener);
      if (wasEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  /// Implemented from [ZoomGesture]. See [ZoomGesture.removeListener].
  ///
  /// Added in version 8.3.0
  @override
  void removeListener(ZoomGestureListener listener) {
    if (_listeners.remove(listener)) {
      if (_listeners.isEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  /// Implemented from [ZoomGesture]. See [ZoomGesture.triggerZoomIn].
  ///
  /// Added in version 8.3.0
  @override
  Future<void> triggerZoomIn() async {
    await _controller?.triggerZoomIn();
  }

  /// Implemented from [ZoomGesture]. See [ZoomGesture.triggerZoomOut].
  ///
  /// Added in version 8.3.0
  @override
  Future<void> triggerZoomOut() async {
    await _controller?.triggerZoomOut();
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'swipeToZoom'};
  }
}

/// Private implementation mixin for [ZoomGesture] that extends [ViewAttachable].
///
/// This mixin must be used on a class that also mixes in [ViewAttachable].
/// It handles the lifecycle of the native zoom gesture controller.
mixin PrivateZoomGesture on ViewAttachable {
  _ZoomGestureController? _controller;
  final List<ZoomGestureListener> _listeners = [];

  @override
  void onViewInitialized(int viewId) {
    _controller = _ZoomGestureController(this as ZoomGesture, viewId);
  }

  @override
  void onDetachFromView() {
    _controller?.dispose();
    _controller = null;
    super.onDetachFromView();
  }
}

class _ZoomGestureController extends BaseController {
  final ZoomGesture _zoomGesture;
  final int _viewId;
  late final CoreMethodHandler _coreMethodHandler;
  bool _listenerRegistered = false;
  StreamSubscription? _streamSubscription;

  _ZoomGestureController(this._zoomGesture, this._viewId) : super(FunctionNames.methodsChannelName) {
    _coreMethodHandler = CoreMethodHandler(methodChannel);
    updateSubscription();
  }

  void _subscribeToEvents() {
    if (_streamSubscription != null) {
      return;
    }
    // Both events also carry a `zoomGesture` field (the serialized ZoomGesture); it is
    // wire-present but unconsumed here -- this controller already reuses the local
    // ZoomGesture/PrivateZoomGesture it was constructed with, so there is nothing to
    // reconstruct it into.
    _streamSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().forView(_viewId).listen((event) {
      if (event.isEvent(FunctionNames.eventZoomInGesture)) {
        notifyZoomInListeners();
      } else if (event.isEvent(FunctionNames.eventZoomOutGesture)) {
        notifyZoomOutListeners();
      }
    });
  }

  void _unsubscribeFromEvents() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void updateSubscription() {
    final privateZoomGesture = _zoomGesture as PrivateZoomGesture;
    final hasListeners = privateZoomGesture._listeners.isNotEmpty;

    if (hasListeners && !_listenerRegistered) {
      _registerListener();
      _subscribeToEvents();
    } else if (!hasListeners && _listenerRegistered) {
      _unregisterListener();
      _unsubscribeFromEvents();
    }
  }

  void _registerListener() {
    if (_listenerRegistered) {
      return;
    }
    _listenerRegistered = true;
    _coreMethodHandler.registerZoomGestureListener(viewId: _viewId);
  }

  void _unregisterListener() {
    if (!_listenerRegistered) {
      return;
    }
    _listenerRegistered = false;
    _coreMethodHandler.unregisterZoomGestureListener(viewId: _viewId);
  }

  void notifyZoomInListeners() {
    final privateZoomGesture = _zoomGesture as PrivateZoomGesture;
    for (var listener in privateZoomGesture._listeners) {
      listener.didZoomInGesture(_zoomGesture);
    }
  }

  void notifyZoomOutListeners() {
    final privateZoomGesture = _zoomGesture as PrivateZoomGesture;
    for (var listener in privateZoomGesture._listeners) {
      listener.didZoomOutGesture(_zoomGesture);
    }
  }

  Future<void> triggerZoomIn() async {
    await _coreMethodHandler.triggerZoomIn(viewId: _viewId);
  }

  Future<void> triggerZoomOut() async {
    await _coreMethodHandler.triggerZoomOut(viewId: _viewId);
  }

  @override
  void dispose() {
    _unregisterListener();
    _unsubscribeFromEvents();
    super.dispose();
  }
}

extension ZoomGestureDeserializer on ZoomGesture {
  static ZoomGesture? fromJSON(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'swipeToZoom':
        return SwipeToZoom();
      case 'pinchToZoom':
        return PinchToZoom();
      default:
        return null;
    }
  }

  static List<ZoomGesture> fromJSONArray(List<dynamic> jsonArray) {
    return jsonArray
        .map((e) => fromJSON(jsonDecode(e as String) as Map<String, dynamic>))
        .whereType<ZoomGesture>()
        .toList();
  }
}
