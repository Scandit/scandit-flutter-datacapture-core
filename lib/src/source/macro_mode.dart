/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

enum MacroMode {
  auto('auto'),
  off('off'),
  on('on');

  const MacroMode(this._name);

  @override
  String toString() => _name;

  final String _name;

  static MacroMode fromJSON(String jsonValue) {
    return MacroMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
