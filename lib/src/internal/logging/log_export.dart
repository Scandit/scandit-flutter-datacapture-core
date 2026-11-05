/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import '../../defaults.dart';
import '../helpers.dart';
import 'log_category.dart';
import 'log_level.dart';
import 'log_record.dart';

/// `Defaults.sdkVersion` is `static late`, so reading it throws until a `DataCaptureContext` has
/// loaded native defaults — mirrors `writeLogs.ts`'s `sdkVersion()` guard.
String _sdkVersion() {
  try {
    return Defaults.sdkVersion;
  } catch (_) {
    return 'unknown';
  }
}

/// One JSON line in the export body's shape for [record].
String serializeLogRecord(LogRecord record) {
  // Drop null-valued keys: `toJson` always writes fields/durationMs/error, while the TS
  // spread omits absent ones, and AC3 asks for a body identical to RN's.
  final json = record.toJson()..removeWhere((_, value) => value == null);
  final error = json['error'];
  if (error is Map) error.removeWhere((_, value) => value == null);
  json['time'] = record.isoTimestamp;
  json['level'] = record.level.tag.trim();
  json['category'] = LogCategory.nameOf(record.category);
  return jsonEncode(json);
}

/// The JSON header of an export. [now] defaults to the current time; exposed for deterministic tests.
String buildLogHeader(LogLevel level, {DateTime? now}) {
  final exportedAt = now ?? DateTime.now();
  return jsonEncode(<String, dynamic>{
    'type': 'scandit-debug-log',
    'formatVersion': 2,
    'sdkVersion': _sdkVersion(),
    // A local DateTime serializes without the `Z` and in the device's offset, while
    // TS's `toISOString()` is always UTC — and AC3 asks for an export identical to RN's.
    'exportedAt': exportedAt.toUtc().toIso8601String(),
    'level': level.tag.trim(),
  });
}

/// Every `FrameworksResult` native implementation wraps a non-map success value in a `data` map
/// entry (jsmobile's convention); Flutter's own `CoreModule.kt`/`.swift` pass the written path
/// through unwrapped instead. Handle both so a future alignment of either convention doesn't
/// silently discard the export's only output (see SDC-33103's `{data: …}` defect).
String? _unwrapWrittenPath(dynamic result) {
  if (result is String) return result;
  if (result is Map) {
    final data = result['data'];
    if (data is String) return data;
  }
  return null;
}

/// Asks the shared native `CoreModule.writeLogs` to export the stored log — [path], or its default
/// file when null — after [flushPending] has handed the queued records to native. Resolves with
/// the absolute path native wrote to. Semantics mirror `writeLogs.ts`.
Future<String> writeLogsImpl(
  String? path,
  LogLevel level, {
  Future<void> Function()? flushPending,
}) async {
  await flushPending?.call();
  final result = await getCoreMethodHandler().executeCore('CoreModule', 'writeLogs', {
    'isEventRegistration': false,
    if (path != null) 'path': path,
    'header': buildLogHeader(level),
  });
  final written = _unwrapWrittenPath(result);
  if (written == null || written.isEmpty) {
    throw StateError('ScanditLogger.writeLogs: the native side did not report where the file was written');
  }
  return written;
}
