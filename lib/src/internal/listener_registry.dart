/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'dart:async';

import 'package:flutter/services.dart';

import '../function_names.dart';
import 'event_stream_extensions.dart';
import 'flutter_event.dart';
import 'generated/core_method_handler.dart';
import 'logging/logging_method_channel.dart';
import 'sdk_logger.dart';

sealed class ListenerTarget {
  const ListenerTarget();

  String get key;

  static const ListenerTarget global = _GlobalTarget();

  factory ListenerTarget.mode(int modeId) = ModeTarget;

  factory ListenerTarget.view(int viewId) = ViewTarget;
}

class ModeTarget extends ListenerTarget {
  final int modeId;

  const ModeTarget(this.modeId);

  @override
  String get key => 'mode:$modeId';
}

class ViewTarget extends ListenerTarget {
  final int viewId;

  const ViewTarget(this.viewId);

  @override
  String get key => 'view:$viewId';
}

class _GlobalTarget extends ListenerTarget {
  const _GlobalTarget();

  @override
  String get key => 'global';
}

typedef RegistryHandler = void Function(List<Object> activeListeners, FlutterEvent event);

class _Handler {
  final List<Object> listeners = [];
  final RegistryHandler handler;

  _Handler(this.handler);
}

class _EventSlot {
  final String eventName;
  final Map<String, _Handler> byTarget = {};
  final List<_Handler> global = [];
  StreamSubscription<FlutterEvent>? subscription;

  _EventSlot(this.eventName);

  bool get isEmpty => byTarget.isEmpty && global.isEmpty;
}

class ListenerRegistry {
  ListenerRegistry._();

  static final ListenerRegistry instance = ListenerRegistry._();

  static void _noopHandler(List<Object> listeners, FlutterEvent event) {}

  CoreMethodHandler _methodHandler = CoreMethodHandler(const LoggingMethodChannel(FunctionNames.methodsChannelName));

  final Map<String, _EventSlot> _slots = {};

  set methodHandler(CoreMethodHandler handler) {
    _methodHandler = handler;
  }

  void resetForTesting() {
    for (final slot in _slots.values) {
      slot.subscription?.cancel();
    }
    _slots.clear();
  }

  void addListener(
    String eventName,
    ListenerTarget target,
    Object listener, {
    RegistryHandler? handler,
    Stream<dynamic>? eventStream,
  }) {
    var slot = _slots[eventName];
    if (slot == null) {
      slot = _EventSlot(eventName);
      _slots[eventName] = slot;
      if (eventStream != null) {
        _subscribe(slot, eventStream);
      }
    } else if (slot.subscription == null && eventStream != null) {
      _subscribe(slot, eventStream);
    }
    final effectiveHandler = handler ?? _noopHandler;

    if (target is _GlobalTarget) {
      _addGlobalListener(slot, listener, effectiveHandler);
      return;
    }

    final existing = slot.byTarget[target.key];
    if (existing == null) {
      slot.byTarget[target.key] = _Handler(effectiveHandler)..listeners.add(listener);
      _nativeAddListener(eventName, target);
      return;
    }
    final replacement = _Handler(handler ?? existing.handler)..listeners.addAll(existing.listeners);
    if (!replacement.listeners.contains(listener)) {
      replacement.listeners.add(listener);
    }
    slot.byTarget[target.key] = replacement;
  }

  List<Object> listenersFor(String eventName, ListenerTarget target) {
    final slot = _slots[eventName];
    if (slot == null) {
      return const [];
    }
    if (target is _GlobalTarget) {
      return [for (final handler in slot.global) ...handler.listeners];
    }
    return List.of(slot.byTarget[target.key]?.listeners ?? const []);
  }

  bool hasListeners(String eventName, ListenerTarget target) {
    return listenersFor(eventName, target).isNotEmpty;
  }

  void removeListener(String eventName, ListenerTarget target, Object listener) {
    final slot = _slots[eventName];
    if (slot == null) {
      SdkLogger.info('ListenerRegistry', 'removeListener', 'No handlers found for event: $eventName');
      return;
    }

    final handler = target is _GlobalTarget
        ? slot.global.where((candidate) => candidate.listeners.contains(listener)).firstOrNull
        : slot.byTarget[target.key];

    if (handler == null) {
      SdkLogger.info(
          'ListenerRegistry', 'removeListener', 'No handler found for event: $eventName with target: ${target.key}');
      return;
    }

    handler.listeners.remove(listener);
    if (handler.listeners.isNotEmpty) {
      return;
    }

    if (target is _GlobalTarget) {
      slot.global.remove(handler);
      if (slot.global.isEmpty) {
        _nativeRemoveListener(eventName, target);
      }
    } else {
      slot.byTarget.remove(target.key);
      _nativeRemoveListener(eventName, target);
    }

    if (slot.isEmpty) {
      _slots.remove(eventName);
      slot.subscription?.cancel();
      slot.subscription = null;
    }
  }

  void addListeners(List<String> eventNames, ListenerTarget target, Object listener) {
    for (final eventName in eventNames) {
      addListener(eventName, target, listener);
    }
  }

  void removeListeners(List<String> eventNames, ListenerTarget target, Object listener) {
    for (final eventName in eventNames) {
      removeListener(eventName, target, listener);
    }
  }

  void _addGlobalListener(_EventSlot slot, Object listener, RegistryHandler handler) {
    if (slot.global.any((candidate) => candidate.listeners.contains(listener))) {
      return;
    }
    final existing = slot.global.where((candidate) => candidate.handler == handler).firstOrNull;
    if (existing == null) {
      if (slot.global.isEmpty) {
        _nativeAddListener(slot.eventName, ListenerTarget.global);
      }
      slot.global.add(_Handler(handler)..listeners.add(listener));
      return;
    }
    existing.listeners.add(listener);
  }

  void _subscribe(_EventSlot slot, Stream<dynamic> eventStream) {
    slot.subscription = eventStream.asFlutterEvents().where((event) => event.isEvent(slot.eventName)).listen((event) {
      _handleEvent(slot, event);
    });
  }

  void _handleEvent(_EventSlot slot, FlutterEvent event) {
    for (final handler in List.of(slot.global)) {
      handler.handler(handler.listeners, event);
    }
    if (event.viewId == null && event.modeId == null) {
      for (final handler in List.of(slot.byTarget.values)) {
        handler.handler(handler.listeners, event);
      }
      return;
    }
    final viewId = event.viewId;
    if (viewId != null) {
      final handler = slot.byTarget['view:$viewId'];
      if (handler != null) {
        handler.handler(handler.listeners, event);
      }
    }
    final modeId = event.modeId;
    if (modeId != null) {
      final handler = slot.byTarget['mode:$modeId'];
      if (handler != null) {
        handler.handler(handler.listeners, event);
      }
    }
  }

  void _nativeAddListener(String eventName, ListenerTarget target) {
    _methodHandler
        .addListener(
          eventName: eventName,
          viewId: target is ViewTarget ? target.viewId : null,
          modeId: target is ModeTarget ? target.modeId : null,
        )
        .catchError((Object error) => _logNativeFailure('addListener', eventName, error));
  }

  void _nativeRemoveListener(String eventName, ListenerTarget target) {
    _methodHandler
        .removeListener(
          eventName: eventName,
          viewId: target is ViewTarget ? target.viewId : null,
          modeId: target is ModeTarget ? target.modeId : null,
        )
        .catchError((Object error) => _logNativeFailure('removeListener', eventName, error));
  }

  void _logNativeFailure(String call, String eventName, Object error) {
    if (error is MissingPluginException) {
      return;
    }
    SdkLogger.error('ListenerRegistry', call, 'Native $call failed for $eventName: $error');
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    for (final element in this) {
      return element;
    }
    return null;
  }
}
