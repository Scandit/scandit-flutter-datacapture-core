/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/src/common.dart';
import 'package:scandit_flutter_datacapture_core/src/data_capture_context.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/torch_state.dart';

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
