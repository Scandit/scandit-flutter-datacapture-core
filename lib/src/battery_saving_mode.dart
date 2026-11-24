/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// A feature that can help you extend the battery life of your phone when you are running low on power. It reduces some of the functions and features that consume more energy.
///
/// Added in version 6.21.0
enum BatterySavingMode {
  /// The battery saving mode is always on, maximising the battery lifetime.
  ///
  /// Added in version 6.21.0
  on('on'),
  /// The battery saving mode is always off, ensuring the standard performance.
  ///
  /// Added in version 6.21.0
  off('off'),
  /// The battery saving mode is automatically enabled when a higher than usual consumption of the battery is detected, balancing performance and battery lifetime.
  ///
  /// Added in version 6.21.0
  auto('auto');

  const BatterySavingMode(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension BatterySavingModeDeserializer on BatterySavingMode {
  static BatterySavingMode fromJSON(String jsonValue) {
    return BatterySavingMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
