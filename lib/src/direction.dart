/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

/// Enumeration for different directions.
///
/// Added in version 6.11.0
enum Direction {
  /// Direction left to right.
  ///
  /// Added in version 6.11.0
  leftToRight('leftToRight'),
  /// Direction right to left.
  ///
  /// Added in version 6.11.0
  rightToLeft('rightToLeft'),
  /// Direction horizontal.
  ///
  /// Added in version 6.11.0
  horizontal('horizontal'),
  /// Direction top to bottom.
  ///
  /// Added in version 6.11.0
  topToBottom('topToBottom'),
  /// Direction bottom to top.
  ///
  /// Added in version 6.11.0
  bottomToTop('bottomToTop'),
  /// Direction vertical.
  ///
  /// Added in version 6.11.0
  vertical('vertical'),
  /// No direction.
  ///
  /// Added in version 6.11.0
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
