/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// Severity level for [ScanditLogger] records.
///
/// Ordered: [off] < [error] < [warn] < [info] < [debug] < [trace]. A record
/// at a given level is emitted only while the logger's configured level is
/// at least as high (and not [off]).
enum LogLevel {
  off(0, 'OFF  '),
  error(1, 'ERROR'),
  warn(2, 'WARN '),
  info(3, 'INFO '),
  debug(4, 'DEBUG'),
  trace(5, 'TRACE');

  const LogLevel(this.rank, this.tag);

  /// Numeric ordering used for level comparisons.
  final int rank;

  /// Fixed-width (5 char) label used by [ScanditLogger.format].
  final String tag;

  /// Returns the [LogLevel] whose [rank] equals [rank], or [LogLevel.off] if
  /// none matches.
  static LogLevel fromRank(int rank) {
    return LogLevel.values.firstWhere((element) => element.rank == rank, orElse: () => LogLevel.off);
  }
}
