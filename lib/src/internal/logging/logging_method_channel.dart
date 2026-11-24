/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/services.dart';

import 'log_category.dart';
import 'log_level.dart';
import 'log_record.dart';
import 'scandit_logger.dart';

/// Dispatcher-boilerplate keys the generated `execute<Module>` entry point
/// injects into every call's arguments map (see
/// `lib/src/internal/generated/core_method_handler.dart`). Stripped before
/// the remaining arguments are logged under `fields['args']` — mirrors
/// `LoggingCommand.extractContextFields`'s `DISPATCHER_KEYS`.
const Set<String> _dispatcherKeys = {'moduleName', 'methodName', 'isEventRegistration'};

/// Arguments promoted to their own top-level `fields` entry instead of being
/// folded into `fields['args']` — mirrors `LoggingCommand.extractContextFields`'s
/// `ID_KEYS`.
const Set<String> _idKeys = {'modeId', 'viewId', 'parentId'};

const String _channelNamePrefix = 'com.scandit.datacapture.';

/// A [MethodChannel] that transparently emits one [LogRecord] into
/// [ScanditLogger] for every [invokeMethod] call — the Dart-side half of the
/// cross-platform bridge interception described in
/// `frameworks/DEBUG_MODE_DESIGN.md`. Mirrors the native `LoggingCommand`
/// (Kotlin/Swift) and the TS `wrapNativeProxy` interceptor.
///
/// Drop-in replacement for [MethodChannel] at every Flutter bridge
/// construction site: it adds no fields, so — like [OptionalMethodChannel] —
/// it stays `const`-constructible.
///
/// Behaviour per call: record a start time, delegate to
/// `super.invokeMethod`, then emit exactly one [LogRecord] on success, or
/// exactly one error-carrying [LogRecord] on failure — and always rethrow,
/// never swallowing the original exception.
class LoggingMethodChannel extends MethodChannel {
  const LoggingMethodChannel(super.name, [super.codec, super.binaryMessenger]);

  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    // Fast path: stays non-`async` so this returns `super.invokeMethod`'s own
    // Future unwrapped, not a fresh one — the per-call cost SDC-33638 removes.
    if (ScanditLogger.getLevel() == LogLevel.off || _isLogStorageCall(arguments)) {
      return super.invokeMethod<T>(method, arguments);
    }
    return _invokeMethodWithLogging<T>(method, arguments);
  }

  // The log file's own commands: a record about storing records would be stored in turn, forever.
  static bool _isLogStorageCall(dynamic arguments) {
    if (arguments is! Map) return false;
    final methodName = arguments['methodName'];
    return methodName == 'appendLogs' || methodName == 'clearLogs';
  }

  Future<T?> _invokeMethodWithLogging<T>(String method, dynamic arguments) async {
    final message = _resolveMessage(method, arguments);
    // Metadata is keyed by the bare method name; `message` is `<Module>.<method>`.
    final metadata = ScanditLogger.getMethodMetadata(_metadataKey(method, arguments));
    final successLevel = metadata?.level ?? LogLevel.debug;
    final successCategory = metadata?.category ?? LogCategory.bridge;
    // A per-frame ack marked Trace is dropped below Trace; skip building its
    // fields unless it fails, because an error record needs them.
    final logsSuccess = ScanditLogger.wouldEmit(successLevel);
    final successFields = logsSuccess ? _extractFields(arguments) : null;
    final source = _sourceForChannel(name);

    // Started AFTER the field extraction above: that work is the
    // logger's own cost, and counting it would both inflate the reported
    // round-trip and, via `_withBridgeOverhead` (dartRoundTrip - nativeWork),
    // charge the logger's overhead to the bridge.
    final stopwatch = Stopwatch()..start();
    try {
      final result = await super.invokeMethod<T>(method, arguments);
      stopwatch.stop();
      ScanditLogger.emit(
        successLevel,
        successCategory,
        source,
        message,
        fields: successFields,
        durationMs: stopwatch.elapsedMilliseconds,
      );
      return result;
    } catch (error) {
      stopwatch.stop();
      ScanditLogger.emit(
        LogLevel.error,
        LogCategory.bridge,
        source,
        message,
        fields: successFields ?? _extractFields(arguments),
        durationMs: stopwatch.elapsedMilliseconds,
        error: LogRecordError(name: error.runtimeType.toString(), message: error.toString()),
      );
      rethrow;
    }
  }

  /// The generated `execute<Module>` entry points (see
  /// `core_method_handler.dart`) fold `moduleName`/`methodName` into the
  /// arguments map and dispatch everything through one opaque channel method
  /// (`executeCore`, `executeBarcode`, ...). When that shape is present, the
  /// real message is `<moduleName>.<methodName>`; otherwise the raw channel
  /// method name is already meaningful (e.g. `getDynamicDefaults`).
  /// The key under which the generated `*_log_metadata.dart` maps store this
  /// call's category: the bare method name the generated handler put into the
  /// arguments map, or the raw channel method for a direct call like
  /// `getDynamicDefaults`.
  static String _metadataKey(String method, dynamic arguments) {
    if (arguments is Map) {
      final methodName = arguments['methodName'];
      if (methodName is String) return methodName;
    }
    return method;
  }

  static String _resolveMessage(String method, dynamic arguments) {
    if (arguments is Map) {
      final moduleName = arguments['moduleName'];
      final methodName = arguments['methodName'];
      if (moduleName is String && methodName is String) {
        return '$moduleName.$methodName';
      }
    }
    return method;
  }

  static Map<String, dynamic>? _extractFields(dynamic arguments) {
    if (arguments is! Map) return null;

    final fields = <String, dynamic>{};
    final inner = <String, dynamic>{};
    arguments.forEach((key, value) {
      if (key is! String) return;
      if (_dispatcherKeys.contains(key)) return;
      if (_idKeys.contains(key)) {
        if (value is num) fields[key] = value;
        return;
      }
      inner[key] = value;
    });
    if (inner.isNotEmpty) {
      fields['args'] = inner;
    }

    return fields.isEmpty ? null : fields;
  }

  /// `com.scandit.datacapture.<module>[.submodule]/<channel>` -> `dart.<module>`.
  static String _sourceForChannel(String channelName) {
    var rest =
        channelName.startsWith(_channelNamePrefix) ? channelName.substring(_channelNamePrefix.length) : channelName;
    final slashIdx = rest.indexOf('/');
    if (slashIdx >= 0) rest = rest.substring(0, slashIdx);
    final dotIdx = rest.indexOf('.');
    final module = dotIdx >= 0 ? rest.substring(0, dotIdx) : rest;
    return 'dart.$module';
  }
}
