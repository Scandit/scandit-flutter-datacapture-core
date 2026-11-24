/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:meta/meta.dart';

import 'log_level.dart';

/// Canonical log record shape — mirrors the TS `LogRecord` interface and the
/// native (Android/iOS) `LogRecord.toBridgePayload()` map shape exactly, so
/// [fromJson] can decode a batch record shipped over the native-log method
/// channel without any translation layer.
class LogRecord {
  /// Creates a [LogRecord] from its already-computed fields. [fields],
  /// [durationMs], and [error] are optional; every other field is required.
  const LogRecord({
    required this.ts,
    required this.level,
    required this.category,
    required this.source,
    required this.message,
    this.fields,
    this.durationMs,
    this.error,
  });

  /// Milliseconds since epoch (UTC).
  final int ts;

  /// Severity of this record.
  final LogLevel level;

  /// A single [LogCategory] bit value (not a mask) — the category this
  /// specific record was tagged with.
  final int category;

  /// e.g. `"dart.core"`, `"android.core"`, `"ios.barcode"`.
  final String source;

  /// The log message.
  final String message;

  /// Optional structured key/value payload attached to this record.
  final Map<String, dynamic>? fields;

  /// Optional duration of the logged operation, in milliseconds.
  final num? durationMs;

  /// Optional captured error metadata for this record.
  final LogRecordError? error;

  /// [ts] rendered as an ISO8601 UTC timestamp — the single form used by both
  /// the human-readable `format` rendering and the `writeLogs` export body, so
  /// the two cannot drift apart. Not part of the public API: `LogRecord` is
  /// exported, this convenience is for the logging package itself.
  @internal
  String get isoTimestamp => DateTime.fromMillisecondsSinceEpoch(ts, isUtc: true).toIso8601String();

  /// Returns a copy of this record with [category] and/or [fields]
  /// overridden; every other field is carried over unchanged. Passing
  /// `null` for either parameter keeps the existing value — there is no way
  /// to clear [fields] via this method.
  LogRecord copyWith({int? category, Map<String, dynamic>? fields}) {
    return LogRecord(
      ts: ts,
      level: level,
      category: category ?? this.category,
      source: source,
      message: message,
      fields: fields ?? this.fields,
      durationMs: durationMs,
      error: error,
    );
  }

  /// Decodes a [LogRecord] from the map shape shipped by the native
  /// (Android/iOS) side's `LogRecord.toBridgePayload()` — the same shape the
  /// batch native-log method channel uses, so no translation layer is
  /// needed.
  factory LogRecord.fromJson(Map<String, dynamic> json) {
    return LogRecord(
      ts: json['ts'] as int,
      level: LogLevel.fromRank(json['level'] as int),
      category: json['category'] as int,
      source: json['source'] as String,
      message: json['message'] as String,
      fields: (json['fields'] as Map?)?.cast<String, dynamic>(),
      durationMs: json['durationMs'] as num?,
      error: json['error'] != null ? LogRecordError.fromJson((json['error'] as Map).cast<String, dynamic>()) : null,
    );
  }

  /// Encodes this record to the same map shape [fromJson] decodes, keyed by
  /// [LogLevel.rank] rather than the [LogLevel] enum value itself.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'ts': ts,
        'level': level.rank,
        'category': category,
        'source': source,
        'message': message,
        'fields': fields,
        'durationMs': durationMs,
        'error': error?.toJson(),
      };
}

/// Captured error metadata for a [LogRecord].
///
/// [ScanditLogger] always drops [stack] from the records it stores.
class LogRecordError {
  const LogRecordError({required this.name, required this.message, this.stack});

  final String name;
  final String message;
  final String? stack;

  factory LogRecordError.fromJson(Map<String, dynamic> json) {
    return LogRecordError(
      name: json['name'] as String,
      message: json['message'] as String,
      stack: json['stack'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'message': message,
        'stack': stack,
      };
}
