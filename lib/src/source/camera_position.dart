/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

/// Added in version 6.7.0
enum CameraPosition {
  /// The camera is attached at the back of the device and is facing away from the user.
  ///
  /// Added in version 6.7.0
  worldFacing('worldFacing'),
  /// The camera is attached on the front of the device and facing towards the user.
  ///
  /// Added in version 6.7.0
  userFacing('userFacing'),
  /// The camera position is unspecified.
  ///
  /// Added in version 6.7.0
  unspecified('unspecified');

  const CameraPosition(this._name);

  @override
  String toString() => _name;

  final String _name;

  static CameraPosition fromJSON(String jsonValue) {
    return CameraPosition.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
