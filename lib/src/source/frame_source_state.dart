/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

/// The different states a frame source can be in.
///
/// Added in version 6.7.0
enum FrameSourceState {
  /// The frame source is on and producing frames.
  ///
  /// Added in version 6.7.0
  on('on'),
  /// The frame source is off and not producing frames.
  ///
  /// Added in version 6.7.0
  off('off'),
  /// The frame source is currently starting (moving from [FrameSourceState.off] to state [FrameSourceState.on]). This value cannot be set directly but is returned by [FrameSource.currentState] to indicate that the frame source is currently starting.
  ///
  /// Added in version 6.7.0
  starting('starting'),
  /// The frame source is currently stopping (moving from [FrameSourceState.on] to state [FrameSourceState.off]). This value cannot be set directly but is returned by [FrameSource.currentState] to indicate that the frame source is currently stopping.
  ///
  /// Added in version 6.7.0
  stopping('stopping'),
  /// The frame source is in standby and not producing frames.
  ///
  /// Added in version 6.7.0
  standby('standby'),
  /// The frame source is currently booting up (moving from [FrameSourceState.off] to state [FrameSourceState.standby]). This value cannot be set directly but is returned by [FrameSource.currentState] to indicate that the frame source is currently booting up.
  ///
  /// Added in version 6.7.0
  bootingUp('bootingUp'),
  /// The frame source is currently waking up (moving from [FrameSourceState.standby] to state [FrameSourceState.on]). This value cannot be set directly but is returned by [FrameSource.currentState] to indicate that the frame source is currently waking up.
  ///
  /// Added in version 6.7.0
  wakingUp('wakingUp'),
  /// The frame source is currently going to sleep (moving from [FrameSourceState.on] to state [FrameSourceState.standby]). This value cannot be set directly but is returned by [FrameSource.currentState] to indicate that the frame source is currently going to sleep.
  ///
  /// Added in version 6.7.0
  goingToSleep('goingToSleep'),
  /// The frame source is currently shutting down (moving from [FrameSourceState.standby] to state [FrameSourceState.off]). This value cannot be set directly but is returned by [FrameSource.currentState] to indicate that the frame source is currently shutting down.
  ///
  /// Added in version 6.7.0
  shuttingDown('shuttingDown');

  const FrameSourceState(this._name);

  @override
  String toString() => _name;

  final String _name;

  static FrameSourceState fromJSON(String? jsonValue) {
    return FrameSourceState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
