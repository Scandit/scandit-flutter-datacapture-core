/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// This class contains the license text and attributions for all third party software used by the Scandit SDK.
///
/// Added in version 7.0.0
class OpenSourceSoftwareLicenseInfo {
  final String _licenseText;

  /// Creates a new license info instance with the specified license text.
  ///
  /// Added in version 7.0.0
  OpenSourceSoftwareLicenseInfo(this._licenseText);

  /// The license text for all third party software used by the Scandit SDK.
  ///
  /// Added in version 7.0.0
  String get licenseText => _licenseText;
}
