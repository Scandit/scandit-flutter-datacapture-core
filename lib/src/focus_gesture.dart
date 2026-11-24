import 'package:scandit_flutter_datacapture_core/src/internal/view_attachable.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'common.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/event_stream_extensions.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/flutter_event.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/core_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/core_plugin_events.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/schema_types.dart' as schema;
import 'package:scandit_flutter_datacapture_core/src/internal/tolerant_payload_parser.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';

/// Listener for observing the focus gesture. This listener is typically used when you want to react to focus gestures being triggered to update UI elements or similar.
///
/// Added in version 8.3.0
abstract class FocusGestureListener {
  /// Triggers a focus as if the gesture was executed.
  ///
  /// Added in version 8.3.0
  void didFocusGesture(FocusGesture focusGesture, PointWithUnit point);
}

/// Common interface for all the focus gestures.
///
/// Added in version 6.7.0
abstract class FocusGesture extends Serializable with ViewAttachable, PrivateFocusGesture {
  /// If enabled triggering the focus gesture will also show a visual indicator. Defaults to *true*.
  ///
  /// Added in version 8.3.0
  bool showUIIndicator = true;
  /// Adds the listener to this gesture.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 8.3.0
  void addListener(FocusGestureListener listener);
  /// Removes a previously added listener from this gesture.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 8.3.0
  void removeListener(FocusGestureListener listener);
  /// Triggers a focus as if the focus gesture was performed.
  ///
  /// Added in version 8.3.0
  Future<void> triggerFocus(PointWithUnit point);
}

/// Tap to focus gesture.
///
/// Added in version 6.7.0
class TapToFocus extends Serializable with ViewAttachable, PrivateFocusGesture implements FocusGesture {
  /// If enabled triggering the focus gesture will also show a visual indicator. Defaults to *true*.
  ///
  /// Added in version 8.3.0
  @override
  bool showUIIndicator;

  /// Constructs a new TapToFocus instance. The focus strategy can be changed in the [CameraSettings] through [CameraSettings.focusGestureStrategy].
  ///
  /// Added in version 6.7.0
  TapToFocus({bool? showUIIndicator}) : showUIIndicator = showUIIndicator ?? true;

  /// Implemented from [FocusGesture]. See [FocusGesture.addListener].
  ///
  /// Added in version 8.3.0
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

  /// Implemented from [FocusGesture]. See [FocusGesture.removeListener].
  ///
  /// Added in version 8.3.0
  @override
  void removeListener(FocusGestureListener listener) {
    if (_listeners.remove(listener)) {
      if (_listeners.isEmpty) {
        _controller?.updateSubscription();
      }
    }
  }

  /// Implemented from [FocusGesture]. See [FocusGesture.triggerFocus].
  ///
  /// Added in version 8.3.0
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
        _handleFocusGesture(event);
      }
    });
  }

  void _handleFocusGesture(FlutterEvent event) {
    final payload = parsePayloadTolerantly<schema.FocusGestureListenerOnFocusGesture>(
      event.payload,
      (raw) => schema.FocusGestureListenerOnFocusGesture.fromJson(raw),
      (raw) {
        final map = raw is Map ? raw : const <String, dynamic>{};
        // `point` is required and is itself an embedded JSON string; a missing/non-string value
        // cannot be decoded, so decline rather than guessing a placeholder point.
        if (map['point'] is! String) return null;
        return schema.FocusGestureListenerOnFocusGesture(
          viewId: map['viewId'] is int ? map['viewId'] as int : _viewId,
          focusGesture: map['focusGesture'] is String ? map['focusGesture'] as String : '',
          point: map['point'] as String,
          event: FunctionNames.eventFocusGesture,
        );
      },
      'onFocusGesture',
      'FocusGestureController',
    );
    if (payload == null) return;

    // `point` is wire-encoded as a JSON *string* (Kotlin: point.toJson(); Swift:
    // pointWithUnit.jsonString), not a nested map -- decode it before constructing PointWithUnit.
    // `focusGesture` is wire-present but unconsumed here: this controller already has the local
    // FocusGesture instance it was constructed with, so there is nothing to reconstruct it into.
    try {
      final pointJson = jsonDecode(payload.point) as Map<String, dynamic>;
      final point = PointWithUnit.fromJSON(pointJson);
      notifyListeners(point);
    } catch (error) {
      developer.log('FocusGestureController onFocusGesture: point payload declined: $error');
    }
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
        return TapToFocus(showUIIndicator: json['showUIIndicator'] as bool? ?? true);
      default:
        return null;
    }
  }
}
