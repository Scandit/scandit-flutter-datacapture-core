/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// Enumeration of possible logo styles shown by the view ([DataCaptureView]) if no viewfinder that includes the logo is shown.
///
/// Added in version 6.8.0
enum LogoStyle {
  /// An extended logo that reads “Scanning By Scandit”.
  ///
  /// Added in version 6.8.0
  extended('extended'),
  /// The minimal logo that reads “Scandit”.
  ///
  /// Added in version 6.8.0
  minimal('minimal');

  const LogoStyle(this._name);

  static LogoStyle fromJSON(String jsonValue) {
    return LogoStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }

  @override
  String toString() => _name;

  final String _name;
}

extension LogoStyleDeserializer on LogoStyle {
  static LogoStyle fromJSON(String jsonValue) => LogoStyle.fromJSON(jsonValue);
}
