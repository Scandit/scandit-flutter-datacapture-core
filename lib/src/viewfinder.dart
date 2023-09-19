/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import '../src/common.dart';
import '../src/defaults.dart';

abstract class Viewfinder implements Serializable {
  final String _type;

  Viewfinder(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

class LaserlineViewfinder extends Viewfinder {
  DoubleWithUnit width;
  Color enabledColor;
  Color disabledColor;

  LaserlineViewfinderStyle _style;
  LaserlineViewfinderStyle get style => _style;

  LaserlineViewfinder._(this._style, this.width, this.enabledColor, this.disabledColor) : super('laserline');

  LaserlineViewfinder()
      : this._(
            Defaults.laserlineViewfinderDefaults.defaultStyle.style,
            Defaults.laserlineViewfinderDefaults.defaultStyle.width,
            Defaults.laserlineViewfinderDefaults.defaultStyle.enabledColor,
            Defaults.laserlineViewfinderDefaults.defaultStyle.disabledColor);

  factory LaserlineViewfinder.withStyle(LaserlineViewfinderStyle style) {
    var styleDefaults = Defaults.laserlineViewfinderDefaults.styles[style];
    if (styleDefaults == null) {
      throw Exception("LaserlineViewfinderDefaults does not contain any defaults for ${style.toString()}");
    }
    return LaserlineViewfinder._(style, styleDefaults.width, styleDefaults.enabledColor, styleDefaults.disabledColor);
  }

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'width': width.toMap(),
      'enabledColor': enabledColor.jsonValue,
      'disabledColor': disabledColor.jsonValue,
      'style': style.toString()
    });
    return json;
  }
}

enum LaserlineViewfinderStyle {
  legacy('legacy'),
  animated('animated');

  const LaserlineViewfinderStyle(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension LaserlineViewfinderStyleDeserializer on LaserlineViewfinderStyle {
  static LaserlineViewfinderStyle fromJSON(String jsonValue) {
    return LaserlineViewfinderStyle.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class RectangularViewfinder extends Viewfinder {
  SizeWithUnitAndAspect _sizeWithUnitAndAspect;
  SizeWithUnitAndAspect get sizeWithUnitAndAspect => _sizeWithUnitAndAspect;

  Color color;
  Color disabledColor;

  RectangularViewfinderAnimation? animation;

  RectangularViewfinderStyle _style;
  RectangularViewfinderStyle get style => _style;

  double dimming;
  double disabledDimming;

  RectangularViewfinderLineStyle _lineStyle;
  RectangularViewfinderLineStyle get lineStyle => _lineStyle;

  void setSize(SizeWithUnit size) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndHeight(size);
  }

  void setWidthAndAspectRatio(DoubleWithUnit width, double heightToWidthAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndAspectRatio(width, heightToWidthAspectRatio);
  }

  void setHeightAndAspectRatio(DoubleWithUnit height, double widthToHeightAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.heightAndAspectRatio(height, widthToHeightAspectRatio);
  }

  void setShorterDimensionAndAspectRatio(double fraction, double aspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.shorterDimensionAndAspectRatio(fraction, aspectRatio);
  }

  RectangularViewfinder._(this._style, this._lineStyle, this._sizeWithUnitAndAspect, this.color, this.dimming,
      this.animation, this.disabledDimming, this.disabledColor)
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
  legacy('legacy'),
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
  Color frameColor = Defaults.aimerViewfinderDefaults.frameColor;
  Color dotColor = Defaults.aimerViewfinderDefaults.dotColor;

  AimerViewfinder() : super('aimer');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({'frameColor': frameColor.jsonValue, 'dotColor': dotColor.jsonValue});
    return json;
  }
}
