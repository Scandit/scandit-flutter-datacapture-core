/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

// ignore_for_file: avoid_print

import 'logging/log_category.dart';
import 'logging/log_level.dart';
import 'logging/scandit_logger.dart';

const String _source = 'dart.core';

/// Legacy internal diagnostic logger, kept for its existing call sites
/// (component/method/issue-shaped, always-on console output). Additionally
/// routes every call into [ScanditLogger] (design doc: "existing sdk_logger.dart
/// — route through ScanditLogger") so these SDK-internal notices also show up
/// in the unified [ScanditLogger.getRecentLogs]/[ScanditLogger.subscribe]
/// stream once a customer opts into debug mode. The `print` calls are
/// unchanged — this is purely additive, no behavior removed.
class SdkLogger {
  static const String _prefix = 'SCANDIT_SDK';

  static void warning(String component, String method, String issue, [String? solution]) {
    final message = StringBuffer('$_prefix WARNING: $component.$method - $issue');
    if (solution != null && solution.isNotEmpty) {
      message.write('. $solution');
    }
    print(message.toString());
    ScanditLogger.emit(
      LogLevel.warn,
      LogCategory.lifecycle,
      _source,
      '$component.$method',
      fields: {
        'issue': issue,
        if (solution != null && solution.isNotEmpty) 'solution': solution,
      },
    );
  }

  static void error(String component, String method, String error, [String? details]) {
    final message = StringBuffer('$_prefix ERROR: $component.$method - $error');
    if (details != null && details.isNotEmpty) {
      message.write('. $details');
    }
    print(message.toString());
    ScanditLogger.emit(
      LogLevel.error,
      LogCategory.lifecycle,
      _source,
      '$component.$method',
      fields: {
        'error': error,
        if (details != null && details.isNotEmpty) 'details': details,
      },
    );
  }

  static void info(String component, String method, String info) {
    print('$_prefix INFO: $component.$method - $info');
    ScanditLogger.emit(
      LogLevel.info,
      LogCategory.lifecycle,
      _source,
      '$component.$method',
      fields: {'info': info},
    );
  }
}
