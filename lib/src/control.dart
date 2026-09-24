/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';

import 'common.dart';
import 'widget_to_base64_converter.dart';

abstract class Control extends Serializable {}

class TorchSwitchControl implements Control {
  Image? _torchOffImage;
  String? _torchOffBase64Image;

  Image? _torchOffPressedImage;
  String? _torchOffPressedBase64Image;

  Image? _torchOnImage;
  String? _torchOnBase64Image;

  Image? _torchOnPressedImage;
  String? _torchOnPressedBase64Image;

  Image? get torchOffImage => _torchOffImage;
  Future<void> setTorchOffImage(Image? image) async {
    _torchOffImage = image;
    _torchOffBase64Image = await _torchOffImage?.base64String;
  }

  Image? get torchOffPressedImage => _torchOffPressedImage;
  Future<void> setTorchOffPressedImage(Image? image) async {
    _torchOffPressedImage = image;
    _torchOffPressedBase64Image = await _torchOffPressedImage?.base64String;
  }

  Image? get torchOnImage => _torchOnImage;
  Future<void> setTorchOnImage(Image? image) async {
    _torchOnImage = image;
    _torchOnBase64Image = await _torchOnImage?.base64String;
  }

  Image? get torchOnPressedImage => _torchOnPressedImage;
  Future<void> setTorchOnPressedImage(Image? image) async {
    _torchOnPressedImage = image;
    _torchOnPressedBase64Image = await _torchOnPressedImage?.base64String;
  }

  @override
  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{
      'type': 'torch',
      'icon': {
        'on': {'default': _torchOnBase64Image, 'pressed': _torchOnPressedBase64Image},
        'off': {'default': _torchOffBase64Image, 'pressed': _torchOffPressedBase64Image}
      }
    };
    return json;
  }
}

class ZoomSwitchControl implements Control {
  Image? _zoomedOutImage;
  String? _zoomedOutBase64Image;

  Image? _zoomedOutPressedImage;
  String? _zoomedOutPressedBase64Image;

  Image? _zoomedInImage;
  String? _zoomedInBase64Image;

  Image? _zoomedInPressedImage;
  String? _zoomedInPressedBase64Image;

  Image? get zoomedOutImage => _zoomedOutImage;
  Future<void> setZoomedOutImage(Image? image) async {
    _zoomedOutImage = image;
    _zoomedOutBase64Image = await image?.base64String;
  }

  Image? get zoomedOutPressedImage => _zoomedOutPressedImage;
  Future<void> setZoomedOutPressedImage(Image? image) async {
    _zoomedOutPressedImage = image;
    _zoomedOutPressedBase64Image = await image?.base64String;
  }

  Image? get zoomedInImage => _zoomedInImage;
  Future<void> setZoomedInImage(Image? image) async {
    _zoomedInImage = image;
    _zoomedInBase64Image = await image?.base64String;
  }

  Image? get zoomedInPressedImage => _zoomedInPressedImage;
  Future<void> setZoomedInPressedImage(Image? image) async {
    _zoomedInPressedImage = image;
    _zoomedInPressedBase64Image = await image?.base64String;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'zoom',
      'icon': {
        'zoomedOut': {'default': _zoomedOutBase64Image, 'pressed': _zoomedOutPressedBase64Image},
        'zoomedIn': {'default': _zoomedInBase64Image, 'pressed': _zoomedInPressedBase64Image}
      }
    };
  }
}
