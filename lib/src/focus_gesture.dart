import 'package:scandit_flutter_datacapture_core/src/internal/view_attachable.dart';

import 'dart:async';
import 'dart:convert';
import 'common.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';

abstract class FocusGestureListener {
  void didFocusGesture(FocusGesture focusGesture, PointWithUnit point);
}

abstract class FocusGesture extends Serializable with ViewAttachable, PrivateFocusGesture {
  bool showUIIndicator = true;
  void addListener(FocusGestureListener listener);
  void removeListener(FocusGestureListener listener);
  Future<void> triggerFocus(PointWithUnit point);
}

class TapToFocus extends Serializable with ViewAttachable, PrivateFocusGesture implements FocusGesture {
  @override
  bool showUIIndicator;

  TapToFocus({bool? showUIIndicator}) : showUIIndicator = showUIIndicator ?? true;

  @override
  void addListener(FocusGestureListener listener) {
    if (!_listeners.contains(listener)) {
      final wasEmpty = _listeners.isEmpty;
      _listeners.add(listener);
      if (wasEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  @override
  void removeListener(FocusGestureListener listener) {
    if (_listeners.remove(listener)) {
      if (_listeners.isEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  @override
  Future<void> triggerFocus(PointWithUnit point) async {
    await _controller?.triggerFocus(point);
  }

  @override
  Map<String, dynamic> toMap() {
    return {'type': 'tapToFocus', 'showUIIndicator': showUIIndicator};
  }
}

/// Private implementation mixin for [FocusGesture] that extends [ViewAttachable].
///
/// This mixin must be used on a class that also mixes in [ViewAttachable].
/// It handles the lifecycle of the native focus gesture controller.
mixin PrivateFocusGesture on ViewAttachable {
  _FocusGestureController? _controller;
  final List<FocusGestureListener> _listeners = [];

  @override
  void onViewInitialized(int viewId) {
    _controller = _FocusGestureController(this as FocusGesture, viewId);
  }

  @override
  void onDetachFromView() {
    _controller?.dispose();
    _controller = null;
    super.onDetachFromView();
  }
}

class _FocusGestureController extends BaseController {
  final FocusGesture _focusGesture;
  final int _viewId;
  late final CoreMethodHandler _coreMethodHandler;
  bool _listenerRegistered = false;
  StreamSubscription? _streamSubscription;

  _FocusGestureController(this._focusGesture, this._viewId) : super(FunctionNames.methodsChannelName) {
    _coreMethodHandler = CoreMethodHandler(methodChannel);
    updateSubscription();
  }

  void _subscribeToEvents() {
    if (_streamSubscription != null) {
      return;
    }
    _streamSubscription = CorePluginEvents.coreEventStream.asFlutterEvents().forView(_viewId).listen((event) {
      if (event.isEvent(FunctionNames.eventFocusGesture)) {
        final pointJson = event.payload['point'] as Map<String, dynamic>;
        final point = PointWithUnit.fromJSON(pointJson);
        notifyListeners(point);
      }
    });
  }

  void _unsubscribeFromEvents() {
    _streamSubscription?.cancel();
    _streamSubscription = null;
  }

  void updateSubscription() {
    final privateFocusGesture = _focusGesture as PrivateFocusGesture;
    final hasListeners = privateFocusGesture._listeners.isNotEmpty;

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
    _coreMethodHandler.registerFocusGestureListener(viewId: _viewId);
  }

  void _unregisterListener() {
    if (!_listenerRegistered) {
      return;
    }
    _listenerRegistered = false;
    _coreMethodHandler.unregisterFocusGestureListener(viewId: _viewId);
  }

  void notifyListeners(PointWithUnit point) {
    final privateFocusGesture = _focusGesture as PrivateFocusGesture;
    for (var listener in privateFocusGesture._listeners) {
      listener.didFocusGesture(_focusGesture, point);
    }
  }

  Future<void> triggerFocus(PointWithUnit point) async {
    await _coreMethodHandler.triggerFocus(viewId: _viewId, pointJson: jsonEncode(point.toMap()));
  }

  @override
  void dispose() {
    _unregisterListener();
    _unsubscribeFromEvents();
    super.dispose();
  }
}

extension FocusGestureDeserializer on FocusGesture {
  static FocusGesture? fromJSON(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'tapToFocus':
        return TapToFocus(
          showUIIndicator: json['showUIIndicator'] as bool? ?? true,
        );
      default:
        return null;
    }
  }
}
