/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

enum VideoResolution {
  @Deprecated('Auto is deprecated. Please use the capture mode\'s recommendedCameraSettings for the best results.')
  auto('auto'),
  hd('hd'),
  fullHd('fullHd'),
  uhd4k('uhd4k');

  const VideoResolution(this._name);

  @override
  String toString() => _name;

  final String _name;

  static VideoResolution fromJSON(String jsonValue) {
    return VideoResolution.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
