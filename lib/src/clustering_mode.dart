/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

/// An enumeration of the clustering modes available.
///
/// Added in version 8.3.0
enum ClusteringMode {
  /// No clustering is performed.
  ///
  /// Added in version 8.3.0
  disabled('disabled'),
  /// Manual clustering is supported. The user can select barcodes which barcodes to cluster using the on-screen UI.
  ///
  /// Added in version 8.3.0
  manual('manual'),
  /// Clustering is automatically performed and cannot be manually tuned.
  ///
  /// Added in version 8.3.0
  auto('auto'),
  /// Clustering is performed automatically, but clusters can also be formed or dissolved manually using the UI.
  ///
  /// Added in version 8.3.0
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
