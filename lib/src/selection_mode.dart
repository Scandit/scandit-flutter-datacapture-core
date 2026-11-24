/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// Controls whether the aimed-at barcode is scanned without user confirmation. Used by [BarcodeCaptureSettings] and [SparkScanSettings].
///
/// Added in version 8.5.0
enum SelectionMode {
  /// Selection is never active. Barcodes are scanned automatically as soon as they are aimed at.
  ///
  /// Added in version 8.5.0
  off('off'),
  /// Selection is always active. The aimed barcode is highlighted but only delivered after the user confirms it — by tapping the preview in BarcodeCapture, or by tapping the dedicated trigger button in SparkScan.
  ///
  /// Added in version 8.5.0
  on('on'),
  /// The SDK decides dynamically whether selection is active, based on device capabilities and scene conditions.
  ///
  /// This is the recommended replacement for the deprecated `ScanIntention.SmartSelection`.
  ///
  /// [SelectionMode.auto] requires the scan intention to be set to [ScanIntention.smart]; with [ScanIntention.manual] it behaves like [SelectionMode.off]. Automatic selection only activates on devices that support Smart.
  ///
  /// Added in version 8.5.0
  auto('auto');

  const SelectionMode(this._name);

  @override
  String toString() => _name;

  final String _name;

  static SelectionMode fromJSON(String jsonValue) {
    return SelectionMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
