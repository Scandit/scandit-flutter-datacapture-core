/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/src/common.dart';
import 'package:scandit_flutter_datacapture_core/src/data_capture_context.dart';
import 'package:scandit_flutter_datacapture_core/src/source/frame_source_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/torch_state.dart';
import 'package:scandit_flutter_datacapture_core/src/source/macro_mode.dart';

/// Interface for producers of frames. Typically this interface is used through [Camera] which gives access to the built-in camera on Flutter. For more sophisticated use cases this interface can be implemented by programmers to support other sources of frames, such as external cameras with proprietary APIs.
///
/// The [FrameSource] interface is currently restricted to frame sources included in the Scandit Data Capture SDK and cannot be used to implement custom frame sources.
///
/// Added in version 6.7.0
abstract class FrameSource implements Serializable {
  /// Readonly attribute for accessing the desired state. Possible states are [FrameSourceState.on], [FrameSourceState.off], [FrameSourceState.standby].
  ///
  /// Added in version 6.7.0
  FrameSourceState get desiredState;
  /// Readonly attribute for accessing the current state. Possible states are [FrameSourceState.on], [FrameSourceState.off], [FrameSourceState.standby], [FrameSourceState.starting], [FrameSourceState.stopping], [FrameSourceState.bootingUp], [FrameSourceState.wakingUp], [FrameSourceState.goingToSleep], [FrameSourceState.shuttingDown].
  ///
  /// The current state cannot be changed directly, but is modified by switchToDesiredState().
  ///
  /// Added in version 6.7.0
  Future<FrameSourceState> get currentState;
  /// The context this frame source is attached to. When the frame source is currently not attached to a context, *null* is returned.
  ///
  /// Added in version 6.7.0
  DataCaptureContext? context;

  /// Sets the desired state of the frame source
  ///
  /// Possible values are [FrameSourceState.on]/[FrameSourceState.off]. The frame source’s state needs to be switched to [FrameSourceState.on] for it to produce frames.
  ///
  /// It is not allowed to set the desired state to [FrameSourceState.starting]/[FrameSourceState.stopping]. These values are only used to report ongoing state transitions.
  ///
  /// In case the desired state is equal to the current state, calling this method has no effect. Otherwise, a call to this method initiates a state transition from the current state to the desired state.
  ///
  /// The state transition is asynchronous, meaning that it may not complete immediately for certain frame source implementations. When a state transition is ongoing, further changes to the desired state are delayed until the state transition completes. Only the last of the desired states will be processed; previous requested state transitions will be cancelled.
  ///
  /// The completion handler is invoked when the state transition finishes either on a background or on the calling thread. *True* is passed to the completion handler in case the state transition is successful, *false* if it either was cancelled or the state transition failed.
  ///
  /// Added in version 6.7.0
  Future<void> switchToDesiredState(FrameSourceState state);
  /// Adds the listener to this frame source.
  ///
  /// In case the same listener is already observing this instance, calling this method will not add the listener again.
  ///
  /// Added in version 6.7.0
  void addListener(FrameSourceListener listener);
  /// Removes a previously added listener from this frame source.
  ///
  /// In case the listener is not currently observing this instance, calling this method has no effect.
  ///
  /// Added in version 6.7.0
  void removeListener(FrameSourceListener listener);
}

/// Added in version 6.7.0
abstract class FrameSourceListener {
  /// Called whenever the frame source’s [FrameSource.currentState] changes, typically after FrameSource.switchToDesiredState(). Depending on the frame source and platform, the new state can be one of the transition values listed on [FrameSourceState], such as [FrameSourceState.starting] or [FrameSourceState.stopping], reported before the state the transition leads to.
  ///
  /// Adding a listener does not trigger this callback; read [FrameSource.currentState] to get the state at the time the listener is added.
  ///
  /// Added in version 6.7.0
  void didChangeState(FrameSource frameSource, FrameSourceState newState);
}

/// Interface definition for a callback to be invoked when the [TorchState] of a [Camera] changes.
///
/// Added in version 6.12.0
abstract class TorchListener {
  /// Called when [TorchState] changed.
  ///
  /// Added in version 6.12.0
  void didChangeTorchToState(TorchState state);
}

/// Interface definition for a callback to be invoked when the [MacroMode] of a [Camera] changes.
///
/// This listener only works when running on iOS. On Android, macro mode changes will not be reported.
///
/// Added in version 8.3.0
abstract class MacroModeListener {
  /// Called when [MacroMode] changed.
  ///
  /// Added in version 8.3.0
  void didChangeMacroMode(MacroMode macroMode);
}

/// Interface definition for a callback to be invoked when the zoom level of a [Camera] changes.
///
/// Added in version 8.4.0
abstract class ZoomListener {
  /// Called when the zoom level of the [Camera] changed. The zoom levels are expressed as zoom factors (e.g. `1.0` means no zoom, `2.0` means 2x zoom).
  ///
  /// Added in version 8.4.0
  void didChangeZoomLevel(double oldZoomLevel, double newZoomLevel);
}
