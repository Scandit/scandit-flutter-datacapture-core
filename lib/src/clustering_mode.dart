/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

enum ClusteringMode {
  disabled('disabled'),
  manual('manual'),
  auto('auto'),
  autoWithManualCorrection('autoWithManualCorrection');

  const ClusteringMode(this._name);

  @override
  String toString() => _name;

  final String _name;

  static ClusteringMode fromJSON(String mode) {
    switch (mode) {
      case 'disabled':
        return ClusteringMode.disabled;
      case 'manual':
        return ClusteringMode.manual;
      case 'auto':
        return ClusteringMode.auto;
      case 'autoWithManualCorrection':
        return ClusteringMode.autoWithManualCorrection;
      default:
        throw ArgumentError('Invalid clustering mode: $mode');
    }
  }
}
