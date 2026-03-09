/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

enum FrameSourceState {
  on('on'),
  off('off'),
  starting('starting'),
  stopping('stopping'),
  standby('standby'),
  bootingUp('bootingUp'),
  wakingUp('wakingUp'),
  goingToSleep('goingToSleep'),
  shuttingDown('shuttingDown');

  const FrameSourceState(this._name);

  @override
  String toString() => _name;

  final String _name;

  static FrameSourceState fromJSON(String? jsonValue) {
    return FrameSourceState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
