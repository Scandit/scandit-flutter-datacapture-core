/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ImageBuffer {
  final Uint8List _imageBytes;

  final int _width;

  final int _heigth;

  ImageBuffer._(this._width, this._heigth, this._imageBytes);

  factory ImageBuffer.fromJSON(Map<String, dynamic> json) {
    return ImageBuffer._(json['width'] as int, json['height'] as int, json['data'] as Uint8List);
  }

  Image? _cachedImage;

  Image get image {
    var cachedImage = _cachedImage;
    if (cachedImage == null) {
      cachedImage = Image.memory(_imageBytes);
      _cachedImage = cachedImage;
    }
    return cachedImage;
  }

  Uint8List get data => _imageBytes;

  int get width => _width;

  int get height => _heigth;
}
