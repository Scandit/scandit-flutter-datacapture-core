/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// Enumeration of possible macro modes to use. This can be used to allow very small codes to be scanned on supported devices.
///
/// To determine if the current device supports macro mode use [Camera.isMacroModeAvailable].
///
/// On Android this enum and its values have no effect.
///
/// Added in version 8.3.0
enum MacroMode {
  /// Automatically enable macro mode depending on focus position, zoom factor, and light level.
  ///
  /// Added in version 8.3.0
  auto('auto'),
  /// Disables macro mode.
  ///
  /// Added in version 8.3.0
  off('off'),
  /// Enables macro mode.
  ///
  /// Added in version 8.3.0
  on('on');

  const MacroMode(this._name);

  @override
  String toString() => _name;

  final String _name;

  static MacroMode fromJSON(String jsonValue) {
    return MacroMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
