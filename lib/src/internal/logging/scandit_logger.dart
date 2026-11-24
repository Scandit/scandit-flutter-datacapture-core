/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/services.dart' show MissingPluginException;
import 'package:meta/meta.dart';

import '../helpers.dart';

import 'log_category.dart';
import 'log_export.dart';
import 'log_level.dart';
import 'log_record.dart';

const int _bufferCapacity = 1000;
const int _nativeQueueCap = 1000;
const int _correlationWindowMs = 10000;
const String _redactedPlaceholder = '[redacted]';

const Set<String> redactedArgKeys = {
  'frameData',
  'viewBytes',
  'licenseKey',
  'deviceName',
  'externalId',
  'deviceOS',
  'deviceModelName',
  'deviceId',
  'barcodeResult',
  'mrzResult',
  'vizResult',
  'mobileDocumentResult',
  'mobileDocumentOcrResult',
  'verificationResult',
  'nfcResult',
  'imageInfo',
  'firstName',
  'lastName',
  'fullName',
  'sex',
  'dateOfBirth',
  'nationality',
  'nationalityISO',
  'address',
  'documentNumber',
  'documentAdditionalNumber',
  'passportNumber',
  'visaNumber',
  'dateOfExpiry',
  'dateOfIssue',
  'age',
  'frontReviewImage',
};

// Log-storage calls carry headers and record batches, never worth storing as a record's args.
const Set<String> redactedArgMethods = {'parseString', 'parseRawData', 'writeLogs', 'appendLogs', 'clearLogs'};

/// Per-method override metadata consumed by [LoggingMethodChannel]. Populated
/// by generated bridge metadata via [ScanditLogger.registerMethodMetadata].
///
/// [level] is the level the method's success record is logged at (generated
/// metadata marks per-frame callbacks [LogLevel.trace]); [category] labels the
/// record. Errors ignore both.
class MethodLogMetadata {
  const MethodLogMetadata({this.level, this.category});

  final LogLevel? level;
  final int? category;
}

/// Snapshot of the logger's configuration, passed to [ScanditLogger.onConfigChange]
/// listeners. Mirrors the TS `LogConfig` interface.
class LogConfig {
  const LogConfig({required this.level});

  final LogLevel level;
}

/// Local diagnostic logger for the Scandit Data Capture SDK (Dart side).
///
/// Privacy: this logger is entirely local to the device. Records live in the
/// in-memory ring buffer, are written to the platform-native log via
/// `dart:developer`'s `log()` and, while the level is above [LogLevel.off],
/// are also stored in a rolling log file in the app's private storage. The
/// only way records leave the app is if you export them via [getRecentLogs] or
/// [writeLogs], or forward them via [subscribe].
///
/// The logger is off by default. Call [setLevel] with anything other than
/// [LogLevel.off] to enable it.
class ScanditLogger {
  ScanditLogger._();

  static LogLevel _level = LogLevel.off;
  static List<LogRecord?> _buffer = List<LogRecord?>.filled(_bufferCapacity, null);
  static int _writeIdx = 0;
  static int _count = 0;
  static final Set<void Function(LogRecord)> _subscribers = {};
  static final Map<String, MethodLogMetadata> _methodMetadata = {};
  static final Set<void Function(LogConfig)> _configListeners = {};
  static List<LogRecord> _pendingForNative = [];
  static final Set<void Function()> _nativeQueueListeners = {};
  static Future<void> Function()? _nativeFlusher;

  /// Sets the minimum severity a record must have to be emitted. The logger
  /// is off by default ([LogLevel.off]); call this with any other
  /// [LogLevel] to enable it.
  static void setLevel(LogLevel level) {
    _level = level;
    _emitConfig();
  }

  /// Returns the currently configured [LogLevel].
  static LogLevel getLevel() => _level;

  /// Subscribes to configuration changes ([setLevel]). The callback fires immediately with the current
  /// configuration when attached, then again on every subsequent change.
  /// Returns a closure that unsubscribes exactly this callback.
  ///
  /// Used by [NativeLogReceiver] to push the Dart-side config to the native
  /// singletons over the bridge. Not part of the customer-facing API.
  ///
  /// Mirrors `ScanditLogger.ts`'s `onConfigChange` exactly, including firing
  /// on attach: without that, a receiver installed after the customer
  /// already called `setLevel` would never learn the level they set.
  @internal
  static void Function() onConfigChange(void Function(LogConfig config) callback) {
    _configListeners.add(callback);
    try {
      callback(_currentConfig());
    } catch (_) {
      // Config listeners must not break the SDK.
    }
    return () => _configListeners.remove(callback);
  }

  static LogConfig _currentConfig() => LogConfig(level: _level);

  /// Notifies config listeners. Iterates a snapshot for the same reason
  /// [_notify] does: a listener's own dispose closure may remove it from
  /// [_configListeners] while this loop is running (a natural
  /// "reinstall replaces itself" pattern), which would otherwise throw
  /// `ConcurrentModificationError` between callbacks.
  static void _emitConfig() {
    if (_configListeners.isEmpty) return;
    final config = _currentConfig();
    for (final listener in _configListeners.toList(growable: false)) {
      try {
        listener(config);
      } catch (_) {
        // Config listeners must not break the SDK.
      }
    }
  }

  @visibleForTesting
  static dynamic redactArgs(dynamic value) {
    return _redactValue(value);
  }

  static dynamic _redactValue(dynamic value) {
    if (value == null) return value;
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty || (trimmed[0] != '{' && trimmed[0] != '[')) {
        return value;
      }
      try {
        final decoded = jsonDecode(trimmed);
        return jsonEncode(_redactValue(decoded));
      } catch (_) {
        return value;
      }
    }
    if (value is List) {
      return value.map(_redactValue).toList();
    }
    if (value is Map) {
      // Platform-channel maps arrive as `Map<Object?, Object?>`, so a nested
      // value can legitimately carry non-String keys. Casting here would throw
      // on the *diagnostic* path and abort a real SDK call, so coerce instead:
      // only a String key can match a redacted key anyway.
      final out = <String, dynamic>{};
      value.forEach((key, v) {
        final k = key is String ? key : '$key';
        out[k] = redactedArgKeys.contains(k) ? _redactedPlaceholder : _redactValue(v);
      });
      return out;
    }
    return value;
  }

  static Map<String, dynamic>? _applyArgPolicy(String message, Map<String, dynamic>? fields) {
    if (fields == null || !fields.containsKey('args')) return fields;
    return <String, dynamic>{
      ...fields,
      'args': _isRedactedArgMethod(message) ? _redactEveryValue(fields['args']) : _redactValue(fields['args']),
    };
  }

  static bool _isRedactedArgMethod(String message) {
    final dot = message.lastIndexOf('.');
    final method = message.substring(dot + 1).replaceFirst(RegExp(r'^\$+'), '');
    return redactedArgMethods.contains(method);
  }

  static dynamic _redactEveryValue(dynamic args) {
    if (args is List) return List<dynamic>.filled(args.length, _redactedPlaceholder);
    if (args is Map) {
      final out = <String, dynamic>{};
      args.forEach((key, _) {
        out[key is String ? key : '$key'] = _redactedPlaceholder;
      });
      return out;
    }
    return _redactedPlaceholder;
  }

  static LogRecordError? _applyErrorPolicy(LogRecordError? error) {
    if (error == null || error.stack == null) return error;
    return LogRecordError(name: error.name, message: error.message);
  }

  /// Whether a record at [level] would survive the current level gate.
  ///
  /// Exposed so hot-path callers — notably [LoggingMethodChannel], which sits
  /// on every Dart→native call including per-frame scanning acks — can skip
  /// building a message, copying the arguments map and running redaction for
  /// a record that [emit] would immediately discard. Allocation-free.
  static bool wouldEmit(LogLevel level) {
    if (level == LogLevel.off) return false;
    if (_level == LogLevel.off) return false;
    return level.rank <= _level.rank;
  }

  /// Records a [LogRecord] and routes it through [_store], [_writeToSink],
  /// and [_notify]. This is the primary "write a record" entry point for
  /// Dart-originated records (as opposed to [ingest], used for
  /// native-originated ones).
  ///
  /// Subject to the level gate: the call is a no-op whenever [wouldEmit]
  /// returns `false` for [level] — i.e. when the logger is off or [level] is
  /// less severe than [getLevel].
  ///
  /// - [level]: severity of this record.
  /// - [category]: the [LogCategory] label this record is tagged with.
  /// - [source]: origin tag, e.g. `"dart.core"`.
  /// - [message]: the log message.
  /// - [fields]: optional structured key/value payload.
  /// - [durationMs]: optional duration of the logged operation, in
  ///   milliseconds.
  /// - [error]: optional captured error metadata.
  static void emit(
    LogLevel level,
    int category,
    String source,
    String message, {
    Map<String, dynamic>? fields,
    num? durationMs,
    LogRecordError? error,
  }) {
    if (!wouldEmit(level)) return;

    final record = LogRecord(
      ts: DateTime.now().millisecondsSinceEpoch,
      level: level,
      category: category,
      source: source,
      message: message,
      fields: _applyArgPolicy(message, fields),
      durationMs: durationMs,
      error: _applyErrorPolicy(error),
    );

    _store(record);
    _enqueueForNative(record);
    _writeToSink(record);
    _notify(record);
  }

  /// Dart-emitted records not yet handed to native storage. Used by [NativeLogReceiver].
  @internal
  static int pendingNativeRecordCount() => _pendingForNative.length;

  /// Removes and returns every record waiting for native storage.
  @internal
  static List<LogRecord> takePendingNativeRecords() {
    final records = _pendingForNative;
    _pendingForNative = [];
    return records;
  }

  /// Calls [callback] whenever a record joins the native queue; returns a detach closure.
  @internal
  static void Function() onNativeRecordQueued(void Function() callback) {
    _nativeQueueListeners.add(callback);
    return () => _nativeQueueListeners.remove(callback);
  }

  static void _enqueueForNative(LogRecord record) {
    _pendingForNative.add(record);
    if (_pendingForNative.length > _nativeQueueCap) _pendingForNative.removeAt(0);
    for (final listener in _nativeQueueListeners.toList(growable: false)) {
      try {
        listener();
      } catch (_) {
        // Queue listeners must not break the SDK.
      }
    }
  }

  /// Writes an [emit]-originated record to the platform-native log via
  /// `dart:developer`'s `log()` (the Dart sink named in the design doc).
  /// [ingest] deliberately does NOT call this — a native-originated record
  /// was already written to logcat/os_log by the native side, and writing it
  /// again here would double-log it.
  static void _writeToSink(LogRecord record) {
    developer.log(format(record), name: 'ScanditLogger', level: _developerLevelFor(record.level));
  }

  /// Maps [LogLevel] to the severity scale `dart:developer.log`'s `level`
  /// parameter expects (`java.util.logging`-style: higher = more severe).
  static int _developerLevelFor(LogLevel level) {
    switch (level) {
      case LogLevel.off:
        return 0;
      case LogLevel.trace:
        return 300;
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warn:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }

  static void _store(LogRecord record) {
    _buffer[_writeIdx] = record;
    _writeIdx = (_writeIdx + 1) % _bufferCapacity;
    _count++;
  }

  /// Notifies subscribers. A subscriber that throws must not break emission
  /// for the rest — the record is still stored, and later subscribers still
  /// run.
  ///
  /// Iterates a snapshot: a callback is allowed to call its own unsubscribe
  /// closure (a natural "log the next record then detach" pattern), which
  /// mutates [_subscribers]. Dart throws `ConcurrentModificationError` for
  /// that during a `for-in` — and it would be thrown *between* callbacks,
  /// outside the per-subscriber `try`, so it would escape [emit] and surface
  /// as a failure of whatever bridge call happened to be logging. (The TS
  /// original iterates the live Set safely only because JS permits deleting
  /// during iteration.)
  static void _notify(LogRecord record) {
    for (final sub in _subscribers.toList(growable: false)) {
      try {
        sub(record);
      } catch (_) {
        // Subscribers must not break the SDK.
      }
    }
  }

  /// Subscribes to every stored [LogRecord] (from both [emit] and [ingest]).
  /// Returns a closure that unsubscribes exactly this callback.
  static void Function() subscribe(void Function(LogRecord record) callback) {
    _subscribers.add(callback);
    return () => _subscribers.remove(callback);
  }

  /// Clears the in-memory records and deletes the log files the SDK stored on the device.
  /// Completes once the files are gone, or at once when no platform side is attached.
  static Future<void> clear() async {
    _buffer = List<LogRecord?>.filled(_bufferCapacity, null);
    _writeIdx = 0;
    _count = 0;
    _pendingForNative = [];
    // An appendLogs already in flight would otherwise land after the delete.
    await flushNative();
    try {
      await getCoreMethodHandler().executeCore('CoreModule', 'clearLogs', {'isEventRegistration': false});
    } on MissingPluginException {
      // The SDK was never initialised: nothing is stored natively.
    }
  }

  /// Number of slots currently holding a record (the buffer is pre-filled with
  /// nulls, so this is *not* `_buffer.length`).
  static int get _liveCount => _count < _bufferCapacity ? _count : _bufferCapacity;

  static List<LogRecord> getRecentLogs() {
    const size = _bufferCapacity;
    final total = _liveCount;
    final start = _count < size ? 0 : _writeIdx;
    // Every slot in [start, start + total) is non-null by construction.
    return List<LogRecord>.generate(total, (i) => _buffer[(start + i) % size]!);
  }

  /// Registers how pending records reach native storage; [NativeLogReceiver] owns it.
  @internal
  static void setNativeFlusher(Future<void> Function()? flusher) => _nativeFlusher = flusher;

  /// Completes once every record queued so far has been handed to native storage.
  @internal
  static Future<void> flushNative() => _nativeFlusher?.call() ?? Future<void>.value();

  /// Writes the log the SDK keeps on the device (records from the native side and from
  /// this layer, oldest first) as a redacted JSON-lines file, and resolves with the
  /// absolute path written.
  ///
  /// Without [path] the file is `scandit-debug-log.jsonl` in the app's cache directory
  /// and is overwritten on every call. An app can only write inside its own storage: a
  /// relative [path] is resolved against the app's documents (iOS) or files (Android)
  /// directory, and an absolute one is used as given and must be writable by the app.
  ///
  /// Rejects when no record is stored (call [setLevel] first) or the destination
  /// cannot be written.
  static Future<String> writeLogs([String? path]) {
    return writeLogsImpl(path, _level, flushPending: flushNative);
  }

  /// Renders [record] as the one-line, human-readable string written to the
  /// platform-native sink by [emit] — see the design doc's "Default string
  /// rendering" section. Field order/padding mirrors `ScanditLogger.ts`
  /// exactly: ISO8601 UTC timestamp, fixed-width level, bracketed+padded
  /// category, padded source, message, then optional `duration=`/`fields=`/
  /// `error=` trailers, all joined by two spaces.
  static String format(LogRecord record) {
    final ts = record.isoTimestamp;
    final category = '[${LogCategory.nameOf(record.category)}]'.padRight(15);
    final source = record.source.padRight(16);
    final parts = <String>[ts, record.level.tag, category, source, record.message];
    if (record.durationMs != null) parts.add('duration=${record.durationMs}ms');
    if (record.fields != null) parts.add('fields=${_formatFields(record.fields!)}');
    if (record.error != null) parts.add('error=${record.error!.name}: ${record.error!.message}');
    return parts.join('  ');
  }

  static String _formatFields(Map<String, dynamic> fields) {
    try {
      return jsonEncode(fields);
    } catch (_) {
      return '[unserializable]';
    }
  }

  /// Merges per-method log metadata into the global registry. Called as a
  /// module-load side effect by generated bridge metadata. Last write wins
  /// for duplicate keys.
  ///
  /// Bridge plumbing, not part of the public logging API — called by the
  /// generated `*_log_metadata.dart` files.
  ///
  /// Deliberately NOT `@internal`: those generated files live in the barcode,
  /// id and label packages, so every call is cross-package by design and
  /// `@internal` makes each one an `invalid_use_of_internal_member` analyzer
  /// warning (which `flutter-lint` fails on).
  static void registerMethodMetadata(Map<String, MethodLogMetadata> metadata) {
    _methodMetadata.addAll(metadata);
  }

  /// Looks up the metadata for a given native method name, if any.
  ///
  /// Bridge plumbing, not part of the public logging API — called by
  /// [LoggingMethodChannel].
  @internal
  static MethodLogMetadata? getMethodMetadata(String methodName) => _methodMetadata[methodName];

  /// Inserts a [LogRecord] produced by the native (Android/iOS) side into the
  /// local buffer.
  ///
  /// Applies the Dart-side level gate so [setLevel] remains the single source
  /// of truth for what lands in the unified buffer. Native already applied its
  /// own per-method level override, so the record is not re-categorised here.
  ///
  /// Skips writing to the platform-native console sink — the native side
  /// already wrote its own line (logcat / os_log).
  ///
  /// Notifies subscribers so live consumers see a unified Dart + native
  /// stream.
  static void ingest(LogRecord record) {
    if (!wouldEmit(record.level)) return;

    final enriched = _withBridgeOverhead(LogRecord(
      ts: record.ts,
      level: record.level,
      category: record.category,
      source: record.source,
      message: record.message,
      fields: _applyArgPolicy(record.message, record.fields),
      durationMs: record.durationMs,
      error: _applyErrorPolicy(record.error),
    ));
    _store(enriched);
    _notify(enriched);
  }

  /// Best-effort correlation: when [record] carries a `durationMs`, walk the ring buffer newest -> oldest
  /// looking for the most recent Dart-side bridge record (any source prefixed
  /// `dart.` — e.g. `dart.core`, `dart.barcode`, one per
  /// [LoggingMethodChannel]'s originating channel) for the same method name
  /// within a 10 s window, and attach
  /// `fields['bridgeOverheadMs'] = dartRoundTrip - nativeWork`. No match ->
  /// [record] is returned unchanged.
  static LogRecord _withBridgeOverhead(LogRecord record) {
    if (record.durationMs == null) return record;
    if (record.source.startsWith('dart.')) return record;
    final nativeMethod = record.message;
    const size = _bufferCapacity;
    final total = _liveCount;
    if (total == 0) return record;
    final writeIdx = _writeIdx;
    // Walk newest -> oldest in the ring buffer. `i <= total <= size`, so
    // `writeIdx - i + size` is always >= 0.
    for (var i = 1; i <= total; i++) {
      final idx = (writeIdx - i + size) % size;
      final candidate = _buffer[idx];
      if (candidate == null) continue;
      if (record.ts - candidate.ts > _correlationWindowMs) break;
      if (!candidate.source.startsWith('dart.')) continue;
      if (candidate.durationMs == null) continue;
      final dot = candidate.message.lastIndexOf('.');
      final candidateMethod = dot >= 0 ? candidate.message.substring(dot + 1) : candidate.message;
      if (candidateMethod != nativeMethod) continue;
      final overheadMs = candidate.durationMs! - record.durationMs!;
      return record.copyWith(fields: {...(record.fields ?? {}), 'bridgeOverheadMs': overheadMs});
    }
    return record;
  }

  /// Resets all static state to its defaults. Test-only seam — production
  /// code never needs to un-configure the singleton.
  @visibleForTesting
  static void resetForTesting() {
    _level = LogLevel.off;
    _buffer = List<LogRecord?>.filled(_bufferCapacity, null);
    _pendingForNative = [];
    _nativeQueueListeners.clear();
    _writeIdx = 0;
    _count = 0;
    _subscribers.clear();
    _methodMetadata.clear();
    _configListeners.clear();
    _nativeFlusher = null;
  }
}
