/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import '../src/defaults.dart';

class ScanditFlutterDataCaptureCore {
  static Future<void> initialize() {
    return Defaults.initializeDefaultsAsync();
  }
}
