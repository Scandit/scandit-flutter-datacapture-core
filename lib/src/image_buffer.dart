/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class ImageBuffer {
  final Uint8List _imageBytes;

  final int _width;

  final int _heigth;

  final String? _filePath;

  ImageBuffer._(this._width, this._heigth, this._imageBytes, this._filePath);

  factory ImageBuffer.fromJSON(Map<String, dynamic> json) {
    Uint8List imageBytes;
    String? filePath;

    if (json['data'] is Uint8List) {
      imageBytes = json['data'] as Uint8List;
      filePath = null;
    } else {
      imageBytes = Uint8List.fromList([]);
      filePath = json['data'];
    }

    return ImageBuffer._(json['width'] as int, json['height'] as int, imageBytes, filePath);
  }

  Image? _cachedImage;

  Image get image {
    var cachedImage = _cachedImage;
    if (cachedImage == null) {
      if (_filePath != null) {
        cachedImage = Image.file(File(_filePath));
      } else {
        cachedImage = Image.memory(_imageBytes);
      }

      _cachedImage = cachedImage;
    }
    return cachedImage;
  }

  Uint8List get data => _imageBytes;

  int get width => _width;

  int get height => _heigth;
}
