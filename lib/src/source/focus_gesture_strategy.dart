/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

enum FocusGestureStrategy {
  none('none'),
  manual('manual'),
  manualUntilCapture('manualUntilCapture'),
  autoOnLocation('autoOnLocation');

  const FocusGestureStrategy(this._name);

  @override
  String toString() => _name;

  final String _name;

  static FocusGestureStrategy fromJSON(String jsonValue) {
    return FocusGestureStrategy.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
