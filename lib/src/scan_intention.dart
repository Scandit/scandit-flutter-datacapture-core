/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// Allows enabling of the [ScanIntention.smart] algorithm that intelligently identifies and scans the intended barcode without requiring precise aiming, eliminating the need to constantly look at the screen and reducing errors.
///
/// Added in version 6.24.0
enum ScanIntention {
  /// No smart algorithms for devices with poorer performance.
  ///
  /// Added in version 6.24.0
  manual('manual'),
  /// On supported devices, it enables the automatic algorithm that intelligently identifies and then scans the barcode that the user intends to capture, reducing errors.
  ///
  /// A frame source that supplies a single image requires [ScanIntention.manual]. [ScanIntention.smart] has to observe a barcode across several frames before it returns it.
  ///
  /// Added in version 6.24.0
  smart('smart'),
  /// Identifies candidates for scanning and then scans the barcode that the user indicates, reducing errors.
  ///
  /// Added in version 7.5.0
  @Deprecated('Use SelectionMode.auto instead. Will be removed in 9.0.')
  smartSelection('smartSelection');

  const ScanIntention(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ScanIntentionSerializer on ScanIntention {
  static ScanIntention fromJSON(String jsonValue) {
    return ScanIntention.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
