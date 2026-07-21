/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_core/src/internal/sdk_logger.dart';

/// A standardized event format for Flutter EventChannel communication.
///
/// Native platforms send events as a Map with:
/// - `event`: The event name (String) - accessed directly without JSON parsing
/// - `payload`: The event payload as a JSON string - decoded lazily when accessed
///
/// This format optimizes event processing by:
/// 1. Allowing immediate event name filtering without JSON parsing
/// 2. Deferring payload parsing until actually needed
/// 3. Caching decoded payloads for repeated access
class FlutterEvent {
  final String eventName;

  final int? modeId;
  final int? viewId;

  final String _payloadJson;

  Map<String, dynamic>? _cachedPayload;

  FlutterEvent._({required this.eventName, this.modeId, this.viewId, required String payloadJson})
      : _payloadJson = payloadJson;

  /// Parses an event from the native Map format sent via EventChannel.
  ///
  /// Expected format:
  /// ```dart
  /// {
  ///   "event": "EventName",      // String - event identifier
  ///   "payload": "{...}",        // JSON String - event data
  ///   "modeId": 123,             // Optional int - for filtering
  ///   "viewId": 456              // Optional int - for filtering
  /// }
  /// ```
  ///
  /// If the input is already a FlutterEvent, returns it as-is (handles double parsing).
  /// Throws [FormatException] if the event format is invalid.
  static FlutterEvent parse(dynamic rawEvent) {
    // If already a FlutterEvent, return it as-is (handles accidental double parsing)
    if (rawEvent is FlutterEvent) {
      return rawEvent;
    }

    if (rawEvent is! Map) {
      throw FormatException('Expected Map, got ${rawEvent.runtimeType}');
    }

    final map = rawEvent;
    final eventName = map['event'];
    final modeId = map['modeId'];
    final viewId = map['viewId'];
    final payloadJson = map['payload'];

    if (eventName is! String) {
      throw FormatException('Missing or invalid "event" field');
    }

    if (payloadJson is! String) {
      throw FormatException('Missing or invalid "payload" field');
    }

    return FlutterEvent._(eventName: eventName, modeId: modeId, viewId: viewId, payloadJson: payloadJson);
  }

  static FlutterEvent? tryParse(dynamic rawEvent) {
    try {
      return parse(rawEvent);
    } catch (e) {
      SdkLogger.error('FlutterEvent', 'tryParse', 'Failed to parse event: $rawEvent, error: $e');
      return null;
    }
  }

  Map<String, dynamic> get payload {
    if (_cachedPayload != null) {
      return _cachedPayload!;
    }

    try {
      final decoded = jsonDecode(_payloadJson);
      if (decoded is! Map<String, dynamic>) {
        throw FormatException('Payload is not a JSON object');
      }
      _cachedPayload = decoded;
      return _cachedPayload!;
    } catch (e) {
      throw FormatException('Invalid payload JSON: $e');
    }
  }

  bool isEvent(String name) => eventName == name;

  bool isForMode(int modeId) {
    try {
      return this.modeId == modeId;
    } catch (_) {
      return false;
    }
  }

  bool isForView(int viewId) {
    try {
      return this.viewId == viewId;
    } catch (_) {
      return false;
    }
  }

  T? getValue<T>(String key) {
    try {
      final value = payload[key];
      return value is T ? value : null;
    } catch (_) {
      return null;
    }
  }

  @override
  String toString() => 'FlutterEvent(eventName: $eventName, payload: $_payloadJson)';
}
