/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'common.dart';
import 'data_capture_context.dart';

enum FrameSourceState { on, off, starting, stopping, standby, bootingUp, wakingUp, goingToSleep, shuttingDown }

extension FrameSourceStateDeserializer on FrameSourceState {
  static FrameSourceState fromJSON(String? jsonValue) {
    switch (jsonValue) {
      case 'on':
        return FrameSourceState.on;
      case 'off':
        return FrameSourceState.off;
      case 'starting':
        return FrameSourceState.starting;
      case 'stopping':
        return FrameSourceState.stopping;
      case 'standby':
        return FrameSourceState.standby;
      case 'bootingUp':
        return FrameSourceState.bootingUp;
      case 'wakingUp':
        return FrameSourceState.wakingUp;
      case 'goingToSleep':
        return FrameSourceState.goingToSleep;
      case 'shuttingDown':
        return FrameSourceState.shuttingDown;
      default:
        throw Exception("Missing FrameSourceState for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case FrameSourceState.on:
        return 'on';
      case FrameSourceState.off:
        return 'off';
      case FrameSourceState.starting:
        return 'starting';
      case FrameSourceState.stopping:
        return 'stopping';
      case FrameSourceState.standby:
        return 'standby';
      case FrameSourceState.bootingUp:
        return 'bootingUp';
      case FrameSourceState.wakingUp:
        return 'wakingUp';
      case FrameSourceState.goingToSleep:
        return 'goingToSleep';
      case FrameSourceState.shuttingDown:
        return 'shuttingDown';
      default:
        throw Exception("Missing Json Value for '$this' frame source");
    }
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
