/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'defaults.dart';

// ignore: avoid_classes_with_only_static_members
/// This class contains the DataCapture version getter.
///
/// Added in version 6.7.0
class DataCaptureVersion {
  /// Returns the version of the Scandit Data Capture SDK.
  ///
  /// Added in version 6.7.0
  static String get sdkVersion => Defaults.sdkVersion;

  /// Returns the version of the Scandit Data Capture Plugin.
  ///
  /// Added in version 6.7.0
  static String get pluginVersion => "8.7.1";
}
