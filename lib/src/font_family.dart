/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

/// Defines the alignment of the text in its view.
///
/// Added in version 7.1.0
enum FontFamily {
  /// Default system font on Android and iOS.
  ///
  /// Added in version 7.1.0
  systemDefault('systemDefault'),
  /// Will use [monospace](https://developer.android.com/reference/kotlin/androidx/glance/text/FontFamily#Monospace()) on Android and [Courier](https://developer.apple.com/fonts/) on iOS.
  ///
  /// Added in version 7.1.0
  modernMono('modernMono'),
  /// Will use [SansSerif](https://developer.android.com/reference/kotlin/androidx/glance/text/FontFamily#SansSerif()) on Android and [Helvetica](https://developer.apple.com/fonts/) on iOS.
  ///
  /// Added in version 7.1.0
  systemSans('systemSans');

  const FontFamily(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension FontFamilySerializer on FontFamily {
  static FontFamily fromJSON(String jsonValue) {
    return FontFamily.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
