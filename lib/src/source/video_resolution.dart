/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

/// Added in version 6.7.0
enum VideoResolution {
  /// [VideoResolution.auto] will select either [VideoResolution.hd] or [VideoResolution.fullHd] based on hardware capabilities. The chosen resolution may change in future versions of the software.
  ///
  /// Added in version 6.7.0
  @Deprecated('Auto is deprecated. Please use the capture mode\'s recommendedCameraSettings for the best results.')
  auto('auto'),
  /// Resolution is 1280x720.
  ///
  /// Added in version 6.7.0
  hd('hd'),
  /// Resolution is 1920x1080.
  ///
  /// Added in version 6.7.0
  fullHd('fullHd'),
  /// Resolution is 3840x2160. Please note: Usage of this resolution is not part of every license. If you encounter issues, please contact us at [support@scandit.com](mailto:support@scandit.com).
  ///
  /// Added in version 6.7.0
  uhd4k('uhd4k');

  const VideoResolution(this._name);

  @override
  String toString() => _name;

  final String _name;

  static VideoResolution fromJSON(String jsonValue) {
    return VideoResolution.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
