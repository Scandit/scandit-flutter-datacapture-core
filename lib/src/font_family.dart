/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum FontFamily {
  systemDefault('systemDefault'),
  modernMono('modernMono'),
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
