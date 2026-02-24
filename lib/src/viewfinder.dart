/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../src/common.dart';
import '../src/defaults.dart';

abstract class Viewfinder with ChangeNotifier implements Serializable {
  final String _type;

  Viewfinder(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

class RectangularViewfinder extends Viewfinder {
  SizeWithUnitAndAspect _sizeWithUnitAndAspect;
  SizeWithUnitAndAspect get sizeWithUnitAndAspect => _sizeWithUnitAndAspect;

  Color _color;
  Color get color => _color;
  set color(Color newValue) {
    _color = newValue;
    notifyListeners();
  }

  Color _disabledColor;
  Color get disabledColor => _disabledColor;
  set disabledColor(Color newValue) {
    _disabledColor = newValue;
    notifyListeners();
  }

  RectangularViewfinderAnimation? _animation;
  RectangularViewfinderAnimation? get animation => _animation;
  set animation(RectangularViewfinderAnimation? newValue) {
    _animation = newValue;
    notifyListeners();
  }

  RectangularViewfinderStyle _style;
  RectangularViewfinderStyle get style => _style;

  double _dimming;
  double get dimming => _dimming;
  set dimming(double newValue) {
    _dimming = newValue;
    notifyListeners();
  }

  double _disabledDimming;
  double get disabledDimming => _disabledDimming;
  set disabledDimming(double newValue) {
    _disabledDimming = newValue;
    notifyListeners();
  }

  RectangularViewfinderLineStyle _lineStyle;
  RectangularViewfinderLineStyle get lineStyle => _lineStyle;

  void setSize(SizeWithUnit size) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndHeight(size);
    notifyListeners();
  }

  void setWidthAndAspectRatio(DoubleWithUnit width, double heightToWidthAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndAspectRatio(width, heightToWidthAspectRatio);
    notifyListeners();
  }

  void setHeightAndAspectRatio(DoubleWithUnit height, double widthToHeightAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.heightAndAspectRatio(height, widthToHeightAspectRatio);
    notifyListeners();
  }

  void setShorterDimensionAndAspectRatio(double fraction, double aspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.shorterDimensionAndAspectRatio(fraction, aspectRatio);
    notifyListeners();
  }

  RectangularViewfinder._(this._style, this._lineStyle, this._sizeWithUnitAndAspect, this._color, this._dimming,
      this._animation, this._disabledDimming, this._disabledColor)
      : super('rectangular');

  RectangularViewfinder()
      : this._(
            Defaults.rectangularViewfinderDefaults.defaultStyle.style,
            Defaults.rectangularViewfinderDefaults.defaultStyle.lineStyle,
            Defaults.rectangularViewfinderDefaults.defaultStyle.size,
            Defaults.rectangularViewfinderDefaults.defaultStyle.color,
            Defaults.rectangularViewfinderDefaults.defaultStyle.dimming,
            Defaults.rectangularViewfinderDefaults.defaultStyle.animation,
            Defaults.rectangularViewfinderDefaults.defaultStyle.disabledDimming,
            Defaults.rectangularViewfinderDefaults.defaultStyle.disabledColor);

  factory RectangularViewfinder.withStyle(RectangularViewfinderStyle style) {
    var styleDefaults = Defaults.rectangularViewfinderDefaults.styles[style];
    if (styleDefaults == null) {
      throw Exception("RectangularViewfinderDefaults does not contain any defaults for ${style.toString()}");
    }
    return RectangularViewfinder._(style, styleDefaults.lineStyle, styleDefaults.size, styleDefaults.color,
        styleDefaults.dimming, styleDefaults.animation, styleDefaults.disabledDimming, styleDefaults.disabledColor);
  }

  factory RectangularViewfinder.withStyleAndLineStyle(
      RectangularViewfinderStyle style, RectangularViewfinderLineStyle lineStyle) {
    var styleDefaults = Defaults.rectangularViewfinderDefaults.styles[style];
    if (styleDefaults == null) {
      throw Exception("RectangularViewfinderDefaults does not contain any defaults for ${style.toString()}");
    }

    return RectangularViewfinder._(style, lineStyle, styleDefaults.size, styleDefaults.color, styleDefaults.dimming,
        styleDefaults.animation, styleDefaults.disabledDimming, styleDefaults.disabledColor);
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'color': color.jsonValue,
      'size': _sizeWithUnitAndAspect.toMap(),
      'animation': animation?.toMap(),
      'style': _style.toString(),
      'dimming': dimming,
      'lineStyle': _lineStyle.toString(),
      'disabledColor': disabledColor.jsonValue
    });
    return json;
  }
}

class RectangularViewfinderAnimation extends Serializable {
  late bool _isLooping;

  RectangularViewfinderAnimation({required bool isLooping}) {
    _isLooping = isLooping;
  }

  bool get isLooping => _isLooping;

  @override
  Map<String, dynamic> toMap() {
    return {'looping': isLooping};
  }
}

enum RectangularViewfinderStyle {
  rounded('rounded'),
  square('square');

  const RectangularViewfinderStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension RectangularViewfinderStyleDeserializer on RectangularViewfinderStyle {
  static RectangularViewfinderStyle fromJSON(String jsonValue) {
    return RectangularViewfinderStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum RectangularViewfinderLineStyle {
  light('light'),
  bold('bold');

  const RectangularViewfinderLineStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension RectangularViewfinderLineStyleDeserializer on RectangularViewfinderLineStyle {
  static RectangularViewfinderLineStyle fromJSON(String jsonValue) {
    return RectangularViewfinderLineStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class AimerViewfinder extends Viewfinder {
  Color _frameColor = Defaults.aimerViewfinderDefaults.frameColor;

  Color get frameColor => _frameColor;
  set frameColor(Color newValue) {
    _frameColor = newValue;
    notifyListeners();
  }

  Color _dotColor = Defaults.aimerViewfinderDefaults.dotColor;

  Color get dotColor => _dotColor;
  set dotColor(Color newValue) {
    _dotColor = newValue;
    notifyListeners();
  }

  AimerViewfinder() : super('aimer');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({'frameColor': frameColor.jsonValue, 'dotColor': dotColor.jsonValue});
    return json;
  }
}
