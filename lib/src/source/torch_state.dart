/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

enum TorchState {
  on('on'),
  off('off'),
  auto('auto');

  const TorchState(this._name);

  @override
  String toString() => _name;

  final String _name;

  static TorchState fromJSON(String jsonValue) {
    return TorchState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
