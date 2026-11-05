/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:typed_data';

import 'image_buffer.dart';

/// Interface for holding frame data from one or more sources (cameras). The concrete type is tied to the frame source that produces the frames.
///
/// The frame data contains one or more image buffers, each of which may have different sizes. Each frame data is guaranteed to have at least one image buffer. Only frame sources that combine the input of multiple frame sources will have more than one image buffer.
///
/// A frame contains the pixel data as well as layout of one particular frame. Frames are immutable and reference counted, so they can be shared by multiple consumers. The frame is returned to the pool (recycled) when all consumers release the frame.
///
/// The frame must be requested during the execution of the listener callback, otherwise the frame will not be available outside of that scope.
///
/// Added in version 6.14.0
abstract class FrameData {
  /// The image buffers contained in this frame data.
  ///
  /// Added in version 6.14.0
  List<ImageBuffer> get imageBuffers;
  /// The image buffer contained in this frame data.
  ///
  /// Added in version 8.3.0
  ImageBuffer get imageBuffer;
  /// The orientation of the image buffer contained in this frame data. The value is the angle that the camera image needs to be rotated clockwise so it shows correctly on the display in its natural orientation. It is 0, 90, 180, or 270. A typical value for this is 90 as most camera modules record the frames in landscape right orientation. Rotating a landscape right frame by 90 degrees will show it correctly on the display in portrait orientation (which is the natural device orientation of most phones).
  ///
  /// Added in version 6.14.0
  int get orientation;
  /// The timestamp of the frame data in ns from the epoch.
  ///
  /// This property is only available when running on Android. On iOS, this property will return `-1`.
  ///
  /// Added in version 8.3.0
  int get timestamp;
}

class DefaultFrameData implements FrameData {
  final List<ImageBuffer> _imageBuffers;
  final int _orientation;
  final int _timestamp;

  DefaultFrameData._(this._orientation, this._imageBuffers, this._timestamp);

  factory DefaultFrameData.fromJSON(Map<String, dynamic>? json) {
    if (json == null) {
      return DefaultFrameData._(
          0,
          [
            ImageBuffer.fromJSON({'width': 0, 'height': 0, 'data': Uint8List(0)})
          ],
          -1);
    }
    return DefaultFrameData._(
        json['orientation'],
        (json['imageBuffers'] as List)
            .map((e) => ImageBuffer.fromJSON(Map<String, dynamic>.from(e as Map)))
            .toList()
            .cast<ImageBuffer>(),
        json['timestamp'] as int? ?? -1);
  }

  @override
  List<ImageBuffer> get imageBuffers => _imageBuffers;

  @override
  ImageBuffer get imageBuffer => _imageBuffers[0];

  @override
  int get orientation => _orientation;

  @override
  int get timestamp => _timestamp;
}
