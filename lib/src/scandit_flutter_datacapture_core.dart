/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import '../src/defaults.dart';
import 'internal/logging/native_log_receiver.dart';

// ignore: avoid_classes_with_only_static_members
/// The container class of the module. Includes only one method, which initializes the core plugin.
///
/// Added in version 6.7.0
class ScanditFlutterDataCaptureCore {
  /// Initializes the core plugin. You need to invoke this method before accessing any of the Scandit Data Capture SDK functionality. The method is internally invoked by [ScanditFlutterDataCaptureBarcode.initialize].
  ///
  /// Added in version 6.7.0
  static Future<void> initialize() {
    // Idempotent: safe to call from every dependent plugin's own
    // `initialize()`, which always calls this one first.
    NativeLogReceiver.install();
    return Defaults.initializeDefaultsAsync();
  }
}
