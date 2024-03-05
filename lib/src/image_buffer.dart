/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/widgets.dart';

class ImageBuffer {
  final String _base64EncodedImage;

  final int _width;

  final int _heigth;

  ImageBuffer._(this._width, this._heigth, this._base64EncodedImage);

  factory ImageBuffer.fromJSON(Map<String, dynamic> json) {
    return ImageBuffer._(json['width'] as int, json['height'] as int, json['data'] as String);
  }

  Image? _cachedImage;

  Image get image {
    var cachedImage = _cachedImage;
    if (cachedImage == null) {
      final decodedImage = base64Decode(_base64EncodedImage);
      cachedImage = Image.memory(decodedImage);
      _cachedImage = cachedImage;
    }
    return cachedImage;
  }

  int get width => _width;

  int get height => _heigth;
}
