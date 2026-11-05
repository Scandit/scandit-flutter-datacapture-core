/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// The orientation of the [ZoomSwitchControl].
///
/// Added in version 8.4.0
enum ZoomSwitchOrientation {
  /// The control is laid out horizontally if the anchor is [Anchor.topCenter] or [Anchor.bottomCenter]. Otherwise, the control is laid out vertically.
  ///
  /// Added in version 8.4.0
  defaultOrientation('default'),
  /// The control is laid out horizontally.
  ///
  /// Added in version 8.4.0
  horizontal('horizontal'),
  /// The control is laid out vertically.
  ///
  /// Added in version 8.4.0
  vertical('vertical');

  const ZoomSwitchOrientation(this._name);

  @override
  String toString() => _name;

  final String _name;

  static ZoomSwitchOrientation fromJSON(String jsonValue) {
    return ZoomSwitchOrientation.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
