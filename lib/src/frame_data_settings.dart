/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'common.dart';

/// This class can be used to configure frame retrieval through file system caching. Users can enable or disable caching, specify the quality of the image to use when compressing frames into JPEG/PNG format, and configure automatic rotation in case the image isn’t following the rotation of the phone. The defaults are chosen to provide a good balance between performance and quality for most use cases.
///
/// Added in version 7.5.0
class FrameDataSettings implements Serializable {
  /// Enables or disables the file system cache for frames. When enabled, processed frames are cached to the file system for improved performance.
  ///
  /// The default value is false.
  ///
  /// Added in version 7.5.0
  bool isFileSystemCacheEnabled = false;
  int _imageQuality = 100;
  /// Enables or disables automatic rotation of frames.
  ///
  /// The default value is false.
  ///
  /// Added in version 7.5.0
  bool isAutoRotateEnabled = false;

  /// Sets the quality of the saved frame images. Higher values produce better quality images but larger file sizes. Valid range is 0-100.
  ///
  /// - 0: Lowest quality, smallest file size
  /// - 100: Highest quality, largest file size
  ///
  /// The default value is 100. Throws an Error if the value is not between 0 and 100.
  ///
  /// Added in version 7.5.0
  int get imageQuality => _imageQuality;

  /// Sets the quality of the saved frame images. Higher values produce better quality images but larger file sizes. Valid range is 0-100.
  ///
  /// - 0: Lowest quality, smallest file size
  /// - 100: Highest quality, largest file size
  ///
  /// The default value is 100. Throws an Error if the value is not between 0 and 100.
  ///
  /// Added in version 7.5.0
  set imageQuality(int quality) {
    if (quality < 0 || quality > 100) {
      throw ArgumentError('Image quality must be between 0 and 100');
    }
    _imageQuality = quality;
  }

  /// Creates new default frame settings. [FrameDataSettings.isFileSystemCacheEnabled] is set to false, [FrameDataSettings.imageQuality] is set to 100, and [FrameDataSettings.isAutoRotateEnabled] is set to false.
  ///
  /// Added in version 7.5.0
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

/// Builder pattern implementation for creating and configuring [FrameDataSettings] instances. Provides a fluent interface for setting frame data handling options such as image quality, file system caching, and automatic rotation.
///
/// Added in version 7.5.0
class FrameDataSettingsBuilder {
  final FrameDataSettings _settings;

  /// Creates a new builder instance with the provided [FrameDataSettings] object.
  ///
  /// Added in version 7.5.0
  FrameDataSettingsBuilder(this._settings);

  /// Enables or disables the file system cache for the frame.
  ///
  /// Enables or disables the file system cache for frames. When enabled, processed frames are cached to the file system for improved performance on subsequent access.
  ///
  /// Added in version 7.5.0
  FrameDataSettingsBuilder enableFileSystemCache(bool enabled) {
    _settings.isFileSystemCacheEnabled = enabled;
    return this;
  }

  /// Sets the image quality (0-100).
  ///
  /// Sets the quality of the saved frame images. Higher values produce better quality images but larger file sizes. Valid range is 0-100.
  ///
  /// - 0: Lowest quality, smallest file size
  /// - 100: Highest quality, largest file size
  ///
  /// Added in version 7.5.0
  FrameDataSettingsBuilder setImageQuality(int quality) {
    _settings.imageQuality = quality;
    return this;
  }

  /// Enables or disables auto-rotation of the frame.
  ///
  /// Enables or disables automatic rotation of frames based on orientation. When enabled, frames are automatically rotated to match the device’s current orientation.
  ///
  /// Added in version 7.5.0
  FrameDataSettingsBuilder enableAutoRotate(bool enabled) {
    _settings.isAutoRotateEnabled = enabled;
    return this;
  }
}
