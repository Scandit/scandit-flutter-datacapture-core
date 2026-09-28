/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

enum FocusRange {
  full('full'),
  near('near'),
  far('far');

  const FocusRange(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension FocusRangeDeserializer on FocusRange {
  static FocusRange focusRangeFromJSON(String jsonValue) {
    return FocusRange.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
