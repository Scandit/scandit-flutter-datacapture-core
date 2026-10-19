/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:typed_data';

import 'image_buffer.dart';

abstract class FrameData {
  List<ImageBuffer> get imageBuffers;
  ImageBuffer get imageBuffer;
  int get orientation;
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
