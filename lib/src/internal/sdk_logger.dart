/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

// ignore_for_file: avoid_print

class SdkLogger {
  static const String _prefix = 'SCANDIT_SDK';

  static void warning(String component, String method, String issue, [String? solution]) {
    final message = StringBuffer('$_prefix WARNING: $component.$method - $issue');
    if (solution != null && solution.isNotEmpty) {
      message.write('. $solution');
    }
    print(message.toString());
  }

  static void error(String component, String method, String error, [String? details]) {
    final message = StringBuffer('$_prefix ERROR: $component.$method - $error');
    if (details != null && details.isNotEmpty) {
      message.write('. $details');
    }
    print(message.toString());
  }

  static void info(String component, String method, String info) {
    print('$_prefix INFO: $component.$method - $info');
  }
}
