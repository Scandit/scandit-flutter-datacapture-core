/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

/// Enumeration of possible focus ranges to use. This can be used to restrict the auto-focus system to only consider objects in a certain range to focus on.
///
/// Added in version 6.7.0
enum FocusRange {
  /// Use the full focus range supported by the camera.
  ///
  /// Added in version 6.7.0
  full('full'),
  /// Only focus on objects that are near to the camera.
  ///
  /// Added in version 6.7.0
  near('near'),
  /// Only focus on objects that are far from the camera.
  ///
  /// Added in version 6.7.0
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
