/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'dart:async';
import 'dart:math';

import 'package:meta/meta.dart';

import '../core_plugin_events.dart';
import '../event_stream_extensions.dart';
import '../flutter_event.dart';
import '../helpers.dart';
import 'log_export.dart';
import 'log_level.dart';
import 'log_record.dart';
import 'scandit_logger.dart';

const String _batchEventName = 'ScanditLogger.batch';
const Duration _fileFlushInterval = Duration(milliseconds: 100);
const int _fileFlushMaxRecords = 50;

/// Subscribes to the native (Android/iOS) `ScanditLogger.batch` event on the
/// core event channel and feeds every record it carries into
/// [ScanditLogger.ingest], unifying the Dart- and native-origin log streams.
///
/// The native side already ships this event unconditionally — see
/// `ScanditLogger.kt`'s `shipBatch`/`CoreModule.kt`'s emitter registration and
/// the analogous iOS `ScanditLogger.swift` — so no native change is needed
/// here, only a Dart-side subscriber.
///
/// The batch payload is a JSON object shaped `{"records": [<LogRecord bridge
/// payload>, ...]}` (see `LogRecord.toBridgePayload()` on both native sides),
/// which matches [LogRecord.fromJson] directly.
///
/// [install] is called once, automatically, from
/// `ScanditFlutterDataCaptureCore.initialize()` — customers never call this
/// themselves (see `frameworks/DEBUG_MODE_DESIGN.md`). It only arms a
/// Dart-only config gate (SDC-33638): the real subscribe + config push run
/// lazily on the first config whose level is not [LogLevel.off], so an app
/// that never enables debug mode never opens the native event channel for
/// it. It is idempotent: calling it again while already armed is a no-op, so
/// a second `initialize()` call (e.g. from a dependent plugin's own
/// bootstrap, which always calls the core one first) never double-arms.
// Plain class + private constructor rather than `abstract final class`: the
// docs signature collector parses with an older analyzer that rejects Dart 3
// class modifiers (see the note in `log_category.dart`).
class NativeLogReceiver {
  NativeLogReceiver._();

  static StreamSubscription<dynamic>? _subscription;
  static void Function()? _disposeConfigListener;
  static void Function()? _disposeGate;
  static void Function()? _disposeFileSink;

  static void install() {
    if (_disposeGate != null) return;
    _disposeGate = ScanditLogger.onConfigChange(_onArmedConfigChange);
  }

  static void _onArmedConfigChange(LogConfig config) {
    // `_subscription` alone is a sufficient guard here, unlike the TS side's extra
    // in-flight flag: `_performInstall` is synchronous and assigns it first.
    if (config.level == LogLevel.off || _subscription != null) return;
    _performInstall();
  }

  static void _performInstall() {
    _subscription = CorePluginEvents.coreEventStream.asFlutterEvents().whereEvent(_batchEventName).listen(_onEvent);

    // Push the Dart-side config (level) to the native
    // singleton. Fires once immediately on attach (carrying whatever level
    // the customer already set before install() ran), then again on every
    // subsequent setLevel call. Without this,
    // the native ScanditLogger stays at its own default (Off) forever, and
    // setLevel on the Dart side never produces any native.* records.
    _disposeConfigListener = ScanditLogger.onConfigChange(_onConfigChange);
    _disposeFileSink = _attachFileSink();
  }

  /// Sends queued records to `appendLogs` at 50 waiting or 100 ms after the first, draining any
  /// queued earlier on attach; the returned detach leaves unsent records queued.
  static void Function() _attachFileSink() {
    Timer? timer;
    var sending = Future<void>.value();

    void sendAll() {
      timer?.cancel();
      timer = null;
      final records = ScanditLogger.takePendingNativeRecords();
      for (var i = 0; i < records.length; i += _fileFlushMaxRecords) {
        final end = min(i + _fileFlushMaxRecords, records.length);
        final lines = records.sublist(i, end).map(serializeLogRecord).join('\n');
        sending = sending.then((_) => _appendLines(lines));
      }
    }

    void onQueued() {
      if (ScanditLogger.pendingNativeRecordCount() >= _fileFlushMaxRecords) {
        sendAll();
      } else {
        timer ??= Timer(_fileFlushInterval, sendAll);
      }
    }

    final detach = ScanditLogger.onNativeRecordQueued(onQueued);
    ScanditLogger.setNativeFlusher(() {
      sendAll();
      return sending;
    });
    if (ScanditLogger.pendingNativeRecordCount() > 0) onQueued();
    return () {
      detach();
      ScanditLogger.setNativeFlusher(null);
      timer?.cancel();
      timer = null;
    };
  }

  static Future<void> _appendLines(String lines) async {
    try {
      await getCoreMethodHandler().executeCore('CoreModule', 'appendLogs', {
        'isEventRegistration': false,
        'lines': lines,
      });
    } catch (_) {
      // A diagnostic path must never break the SDK.
    }
  }

  static void _onConfigChange(LogConfig config) {
    // Fire-and-forget: a diagnostic path must never throw into, or block,
    // whatever call triggered a config change.
    unawaited(_pushConfig(config));
  }

  /// Sends the current config to native `CoreModule.setLoggerConfig`, over
  /// the same `executeCore` dispatch every other Core bridge call uses.
  /// `level` is the numeric rank ([LogLevel.rank]) -- native's
  /// `handleSetLoggerConfig` reads it via `LogLevel.fromRank`, not a string.
  static Future<void> _pushConfig(LogConfig config) async {
    try {
      await getCoreMethodHandler().executeCore('CoreModule', 'setLoggerConfig', {
        'isEventRegistration': false,
        'level': config.level.rank,
      });
    } catch (_) {
      // Failures must never propagate -- a diagnostic path must never break
      // the SDK.
    }
  }

  static void _onEvent(FlutterEvent event) {
    // Nothing to ingest while the logger is off — skip decoding the batch.
    if (ScanditLogger.getLevel() == LogLevel.off) return;

    final records = event.payload['records'];
    if (records is! List) return;

    for (final raw in records) {
      if (raw is! Map) continue;
      try {
        ScanditLogger.ingest(LogRecord.fromJson(raw.cast<String, dynamic>()));
      } catch (_) {
        // A single malformed record must not break the rest of the batch.
      }
    }
  }

  /// Tears down the gate and (if it fired) the subscription, so [install]
  /// can be exercised again from a clean slate. Test-only seam — production
  /// code never un-installs.
  @visibleForTesting
  static void resetForTesting() {
    _subscription?.cancel();
    _subscription = null;
    _disposeConfigListener?.call();
    _disposeConfigListener = null;
    _disposeFileSink?.call();
    _disposeFileSink = null;
    _disposeGate?.call();
    _disposeGate = null;
  }
}
