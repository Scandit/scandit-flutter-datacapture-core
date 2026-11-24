/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

/// Possible values for the torch state.
///
/// Added in version 6.7.0
enum TorchState {
  /// Value to indicate that the torch is turned on.
  ///
  /// Added in version 6.7.0
  on('on'),
  /// Value to indicate that the torch is turned off.
  ///
  /// Added in version 6.7.0
  off('off'),
  /// Value to indicate that the torch is managed automatically. The torch is turned on or off based on the available illumination.
  ///
  /// This is an experimental feature. This functionality may or may not work for your use case or may be removed in future version of this software.
  ///
  /// Added in version 6.7.0
  auto('auto');

  const TorchState(this._name);

  @override
  String toString() => _name;

  final String _name;

  static TorchState fromJSON(String jsonValue) {
    return TorchState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
