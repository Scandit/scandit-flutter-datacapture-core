/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'image_buffer.dart';

abstract class FrameData {
  List<ImageBuffer> get imageBuffers;
  int get orientation;
}

class DefaultFrameData implements FrameData {
  final List<ImageBuffer> _imageBuffers;
  final int _orientation;

  DefaultFrameData._(this._orientation, this._imageBuffers);

  factory DefaultFrameData.fromJSON(Map<String, dynamic> json) {
    return DefaultFrameData._(
        json['orientation'],
        (json['imageBuffers'] as List)
            .map((e) => ImageBuffer.fromJSON(Map<String, dynamic>.from(e as Map)))
            .toList()
            .cast<ImageBuffer>());
  }

  @override
  List<ImageBuffer> get imageBuffers => _imageBuffers;

  @override
  int get orientation => _orientation;
}
