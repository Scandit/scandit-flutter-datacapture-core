/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

enum CameraPosition {
  worldFacing('worldFacing'),
  userFacing('userFacing'),
  unspecified('unspecified');

  const CameraPosition(this._name);

  @override
  String toString() => _name;

  final String _name;

  static CameraPosition fromJSON(String jsonValue) {
    return CameraPosition.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
