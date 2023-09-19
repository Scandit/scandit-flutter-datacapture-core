/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum Direction {
  leftToRight('leftToRight'),
  rightToLeft('rightToLeft'),
  horizontal('horizontal'),
  topToBottom('topToBottom'),
  bottomToTop('bottomToTop'),
  vertical('vertical'),
  none('none');

  const Direction(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension DirectionDeserializer on Direction {
  static Direction fromJSON(String jsonValue) {
    return Direction.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
