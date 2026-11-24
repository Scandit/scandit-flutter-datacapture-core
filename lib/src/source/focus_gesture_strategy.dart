/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

/// Enumeration of possible focus gesture strategies to use.
///
/// Added in version 6.7.0
enum FocusGestureStrategy {
  /// No effect when performing a focus gesture.
  ///
  /// Added in version 6.7.0
  none('none'),
  /// Focus on PoI and only change with next focus gesture.
  ///
  /// Added in version 6.7.0
  manual('manual'),
  /// Focus on PoI and reset to previous focus strategy on capture.
  ///
  /// Added in version 6.7.0
  manualUntilCapture('manualUntilCapture'),
  /// Continuously focus on the location of the gesture and only change with next focus gesture.
  ///
  /// Added in version 6.7.0
  autoOnLocation('autoOnLocation');

  const FocusGestureStrategy(this._name);

  @override
  String toString() => _name;

  final String _name;

  static FocusGestureStrategy fromJSON(String jsonValue) {
    return FocusGestureStrategy.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
