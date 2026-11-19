/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'common.dart';

class FrameDataSettings implements Serializable {
  bool isFileSystemCacheEnabled = false;
  int _imageQuality = 100;
  bool isAutoRotateEnabled = false;

  int get imageQuality => _imageQuality;

  set imageQuality(int quality) {
    if (quality < 0 || quality > 100) {
      throw ArgumentError('Image quality must be between 0 and 100');
    }
    _imageQuality = quality;
  }

  FrameDataSettings();

  @override
  Map<String, dynamic> toMap() {
    return {
      'sc_frame_isFileSystemCacheEnabled': isFileSystemCacheEnabled,
      'sc_frame_imageQuality': imageQuality,
      'sc_frame_autoRotate': isAutoRotateEnabled,
    };
  }
}

class FrameDataSettingsBuilder {
  final FrameDataSettings _settings;

  FrameDataSettingsBuilder(this._settings);

  /// Enables or disables the file system cache for the frame.
  FrameDataSettingsBuilder enableFileSystemCache(bool enabled) {
    _settings.isFileSystemCacheEnabled = enabled;
    return this;
  }

  /// Sets the image quality (0-100).
  FrameDataSettingsBuilder setImageQuality(int quality) {
    _settings.imageQuality = quality;
    return this;
  }

  /// Enables or disables auto-rotation of the frame.
  FrameDataSettingsBuilder enableAutoRotate(bool enabled) {
    _settings.isAutoRotateEnabled = enabled;
    return this;
  }
}
