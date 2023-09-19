/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'camera.dart';
import 'common.dart';
import 'data_capture_context.dart';

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
}

extension FrameSourceStateDeserializer on FrameSourceState {
  static FrameSourceState fromJSON(String? jsonValue) {
    return FrameSourceState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

abstract class FrameSource implements Serializable {
  FrameSourceState get desiredState;
  Future<FrameSourceState> get currentState;
  DataCaptureContext? context;

  Future<void> switchToDesiredState(FrameSourceState state);
  void addListener(FrameSourceListener listener);
  void removeListener(FrameSourceListener listener);
}

abstract class FrameSourceListener {
  void didChangeState(FrameSource frameSource, FrameSourceState newState);
}

abstract class TorchListener {
  void didChangeTorchToState(TorchState state);
}
