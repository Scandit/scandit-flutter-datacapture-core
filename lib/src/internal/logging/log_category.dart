/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// Labels for [ScanditLogger] records. A [LogRecord.category] is always exactly
/// one of these values; filtering is by [LogLevel] alone.
// Deliberately NOT `abstract final class`: the docs pipeline's signature
// collector (docs/scripts/collect-signatures-dart) parses these sources with an
// older analyzer that rejects Dart 3 class modifiers with
// `EXTRANEOUS_MODIFIER`. A private constructor gives the same
// non-instantiable, non-extendable namespace and parses everywhere.
class LogCategory {
  LogCategory._();

  /// Dart<->native method-channel calls — e.g. mode enable/disable,
  /// `applySettings`, and other context-state mutations that flow over the
  /// bridge. Emitted by [LoggingMethodChannel].
  static const int bridge = 1 << 0;

  /// Mode/component create and dispose notices, plus the legacy
  /// `SdkLogger` warning/error/info calls.
  static const int lifecycle = 1 << 1;

  /// Listener subscribe/unsubscribe.
  static const int listener = 1 << 2;

  /// High-frequency event dispatch, e.g. per-frame scan acks. Methods carrying
  /// this label are logged at [LogLevel.trace].
  static const int events = 1 << 3;

  /// Returns the display name [ScanditLogger.format] uses for a category
  /// value; `'Unknown'` for anything else.
  static String nameOf(int category) {
    switch (category) {
      case bridge:
        return 'Bridge';
      case lifecycle:
        return 'Lifecycle';
      case listener:
        return 'Listener';
      case events:
        return 'Events';
      default:
        return 'Unknown';
    }
  }
}
