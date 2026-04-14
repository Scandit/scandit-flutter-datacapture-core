import 'package:scandit_flutter_datacapture_core/src/internal/view_attachable.dart';

import 'dart:async';
import 'common.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';

abstract class ZoomGestureListener {
  void didZoomInGesture(ZoomGesture zoomGesture);
  void didZoomOutGesture(ZoomGesture zoomGesture);
}

abstract class ZoomGesture extends Serializable with ViewAttachable, PrivateZoomGesture {
  void addListener(ZoomGestureListener listener);
  void removeListener(ZoomGestureListener listener);
  Future<void> triggerZoomIn();
  Future<void> triggerZoomOut();
}

class SwipeToZoom extends Serializable with ViewAttachable, PrivateZoomGesture implements ZoomGesture {
  SwipeToZoom();

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

  @override
  void removeListener(ZoomGestureListener listener) {
    if (_listeners.remove(listener)) {
      if (_listeners.isEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  @override
  Future<void> triggerZoomIn() async {
    await _controller?.triggerZoomIn();
  }

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
      default:
        return null;
    }
  }
}
