/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

enum ZoomSwitchOrientation {
  defaultOrientation('default'),
  horizontal('horizontal'),
  vertical('vertical');

  const ZoomSwitchOrientation(this._name);

  @override
  String toString() => _name;

  final String _name;

  static ZoomSwitchOrientation fromJSON(String jsonValue) {
    return ZoomSwitchOrientation.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
