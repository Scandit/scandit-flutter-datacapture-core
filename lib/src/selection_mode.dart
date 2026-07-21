/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum SelectionMode {
  off('off'),
  on('on'),
  auto('auto');

  const SelectionMode(this._name);

  @override
  String toString() => _name;

  final String _name;

  static SelectionMode fromJSON(String jsonValue) {
    return SelectionMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
