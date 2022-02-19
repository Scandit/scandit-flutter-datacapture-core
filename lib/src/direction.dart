/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

enum Direction { leftToRight, rightToLeft, horizontal, topToBottom, bottomToTop, vertical, none }

extension DirectionDeserializer on Direction {
  static Direction fromJSON(String jsonValue) {
    return Direction.values.firstWhere((element) => element.jsonValue == jsonValue);
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    return toString().split('.').last;
  }
}
