/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:meta/meta.dart';

abstract class Serializable {
  Map<String, dynamic> toMap();
}

@immutable
class MarginsWithUnit implements Serializable {
  final DoubleWithUnit left;
  final DoubleWithUnit top;
  final DoubleWithUnit right;
  final DoubleWithUnit bottom;

  MarginsWithUnit(this.left, this.top, this.right, this.bottom);

  MarginsWithUnit.fromJSON(Map<String, dynamic> json)
      : this(
            DoubleWithUnit.fromJSON(json['left'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['top'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['right'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['bottom'] as Map<String, dynamic>));

  @override
  Map<String, dynamic> toMap() {
    return {'left': left.toMap(), 'right': right.toMap(), 'top': top.toMap(), 'bottom': bottom.toMap()};
  }
}

@immutable
class PointWithUnit implements Serializable {
  final DoubleWithUnit x;
  final DoubleWithUnit y;

  static PointWithUnit get zero => PointWithUnit(DoubleWithUnit.zero, DoubleWithUnit.zero);

  PointWithUnit(this.x, this.y);

  PointWithUnit.fromJSON(Map<String, dynamic> json)
      : this(DoubleWithUnit.fromJSON(json['x'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['y'] as Map<String, dynamic>));

  @override
  Map<String, dynamic> toMap() {
    return {'x': x.toMap(), 'y': y.toMap()};
  }
}

@immutable
class DoubleWithUnit implements Serializable {
  final double value;
  final MeasureUnit unit;

  static DoubleWithUnit get zero => DoubleWithUnit(0.0, MeasureUnit.fraction);

  DoubleWithUnit(this.value, this.unit);

  DoubleWithUnit.fromJSON(Map<String, dynamic> json)
      : this((json['value'] as num).toDouble(), MesaureUnitDeserializer.fromJSON(json['unit'] as String));

  Map<String, dynamic> toMap() {
    return {'value': value, 'unit': unit.jsonValue};
  }
}

enum MeasureUnit { dip, pixel, fraction }

extension MesaureUnitDeserializer on MeasureUnit {
  static MeasureUnit fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'dip':
        return MeasureUnit.dip;
      case 'pixel':
        return MeasureUnit.pixel;
      case 'fraction':
        return MeasureUnit.fraction;
      default:
        throw Exception("Missing MeasureUnit for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case MeasureUnit.dip:
        return 'dip';
      case MeasureUnit.pixel:
        return 'pixel';
      case MeasureUnit.fraction:
        return 'fraction';
      default:
        throw Exception("Missing Json Value for '$this' measure unit");
    }
  }
}

enum Anchor { topLeft, topCenter, topRight, centerLeft, center, centerRight, bottomLeft, bottomCenter, bottomRight }

extension AnchorDeserializer on Anchor {
  static Anchor fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'topLeft':
        return Anchor.topLeft;
      case 'topCenter':
        return Anchor.topCenter;
      case 'topRight':
        return Anchor.topRight;
      case 'centerLeft':
        return Anchor.centerLeft;
      case 'center':
        return Anchor.center;
      case 'centerRight':
        return Anchor.centerRight;
      case 'bottomLeft':
        return Anchor.bottomLeft;
      case 'bottomCenter':
        return Anchor.bottomCenter;
      case 'bottomRight':
        return Anchor.bottomRight;
      default:
        throw Exception("Missing Anchor for '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case Anchor.topLeft:
        return 'topLeft';
      case Anchor.topCenter:
        return 'topCenter';
      case Anchor.topRight:
        return 'topRight';
      case Anchor.centerLeft:
        return 'centerLeft';
      case Anchor.center:
        return 'center';
      case Anchor.centerRight:
        return 'centerRight';
      case Anchor.bottomLeft:
        return 'bottomLeft';
      case Anchor.bottomCenter:
        return 'bottomCenter';
      case Anchor.bottomRight:
        return 'bottomRight';
      default:
        throw Exception("Missing Json Value for '$this' anchor");
    }
  }
}

@immutable
class Point implements Serializable {
  final double _x;
  double get x => _x;

  final double _y;
  double get y => _y;

  Point(this._x, this._y);

  Point.fromJSON(Map<String, dynamic> json) : this((json['x'] as num).toDouble(), (json['y'] as num).toDouble());

  @override
  Map<String, dynamic> toMap() {
    return {'x': _x, 'y': _y};
  }
}

@immutable
class Quadrilateral implements Serializable {
  final Point _topLeft;
  Point get topLeft => _topLeft;

  final Point _topRight;
  Point get topRight => _topRight;

  final Point _bottomRight;
  Point get bottomRight => _bottomRight;

  final Point _bottomLeft;
  Point get bottomLeft => _bottomLeft;

  Quadrilateral(this._topLeft, this._topRight, this._bottomRight, this._bottomLeft);

  Quadrilateral.fromJSON(Map<String, dynamic> json)
      : this(Point.fromJSON(json['topLeft']), Point.fromJSON(json['topRight']), Point.fromJSON(json['bottomRight']),
            Point.fromJSON(json['bottomLeft']));

  @override
  Map<String, dynamic> toMap() {
    return {
      'topLeft': _topLeft.toMap(),
      'topRight': _topRight.toMap(),
      'bottomRight': _bottomRight.toMap(),
      'bottomLeft': _bottomLeft.toMap()
    };
  }
}

enum CompositeFlag { none, unknown, linked, gs1TypeA, gs1TypeB, gs1TypeC }

extension CompositeFlagDeserializer on CompositeFlag {
  static CompositeFlag fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'none':
        return CompositeFlag.none;
      case 'unknown':
        return CompositeFlag.unknown;
      case 'linked':
        return CompositeFlag.linked;
      case 'gs1TypeA':
        return CompositeFlag.gs1TypeA;
      case 'gs1TypeB':
        return CompositeFlag.gs1TypeB;
      case 'gs1TypeC':
        return CompositeFlag.gs1TypeC;
      default:
        throw Exception("Missing CompositeFlag for '$jsonValue'");
    }
  }
}

class SizeWithUnitAndAspect implements Serializable {
  SizeWithUnit _widthAndHeight;
  SizeWithUnit get widthAndHeight => _widthAndHeight;

  SizeWithAspect _widthAndAspectRatio;
  SizeWithAspect get widthAndAspectRatio => _widthAndAspectRatio;

  SizeWithAspect _heightAndAspectRatio;
  SizeWithAspect get heightAndAspectRatio => _heightAndAspectRatio;

  SizingMode get sizingMode => _sizingMode();

  SizingMode _sizingMode() {
    if (_widthAndAspectRatio != null) {
      return SizingMode.widthAndAspectRatio;
    }
    if (_heightAndAspectRatio != null) {
      return SizingMode.heightAndAspectRatio;
    }
    return SizingMode.widthAndHeight;
  }

  SizeWithUnitAndAspect.widthAndHeight(SizeWithUnit widthAndHeight) {
    _widthAndHeight = widthAndHeight;
  }

  SizeWithUnitAndAspect.widthAndAspectRatio(DoubleWithUnit width, double aspectRatio) {
    _widthAndAspectRatio = SizeWithAspect(width, aspectRatio);
  }

  SizeWithUnitAndAspect.heightAndAspectRatio(DoubleWithUnit height, double aspectRatio) {
    _heightAndAspectRatio = SizeWithAspect(height, aspectRatio);
  }

  factory SizeWithUnitAndAspect.fromJSON(Map<String, dynamic> json) {
    if (json.containsKey('width') && json.containsKey('height')) {
      return SizeWithUnitAndAspect.widthAndHeight(SizeWithUnit.fromJSON(json));
    } else if (json.containsKey('width') && json.containsKey('aspect')) {
      return SizeWithUnitAndAspect.widthAndAspectRatio(
          DoubleWithUnit.fromJSON(json['width']), (json['aspect'] as num).toDouble());
    } else if (json.containsKey('height') && json.containsKey('aspect')) {
      return SizeWithUnitAndAspect.heightAndAspectRatio(
          DoubleWithUnit.fromJSON(json['height']), (json['aspect'] as num).toDouble());
    }
    throw Exception("Unable to create an instance of SizeWithUnitAndAspect from the given json");
  }

  @override
  Map<String, dynamic> toMap() {
    if (_widthAndAspectRatio != null) {
      return {'width': _widthAndAspectRatio.size.toMap(), 'aspect': _widthAndAspectRatio.aspect};
    }
    if (_heightAndAspectRatio != null) {
      return {'height': _heightAndAspectRatio.size.toMap(), 'aspect': _heightAndAspectRatio.aspect};
    }
    return _widthAndHeight.toMap();
  }
}

@immutable
class SizeWithUnit implements Serializable {
  final DoubleWithUnit _width;
  DoubleWithUnit get width => _width;

  final DoubleWithUnit _height;
  DoubleWithUnit get height => _height;

  SizeWithUnit(this._width, this._height);

  SizeWithUnit.fromJSON(Map<String, dynamic> json)
      : this(DoubleWithUnit.fromJSON(json['width']), DoubleWithUnit.fromJSON(json['height']));

  @override
  Map<String, dynamic> toMap() {
    return {'width': _width.toMap(), 'height': _height.toMap()};
  }
}

@immutable
class SizeWithAspect implements Serializable {
  final DoubleWithUnit _size;
  DoubleWithUnit get size => _size;

  final double _aspect;
  double get aspect => _aspect;

  SizeWithAspect(this._size, this._aspect);

  SizeWithAspect.fromJSON(Map<String, dynamic> json)
      : this(DoubleWithUnit.fromJSON(json['size']), (json['aspect'] as num).toDouble());

  @override
  Map<String, dynamic> toMap() {
    return {'size': _size.toMap(), 'aspect': aspect};
  }
}

enum SizingMode { widthAndHeight, widthAndAspectRatio, heightAndAspectRatio }

extension SizingModeDeserializer on SizingMode {
  static SizingMode fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'widthAndHeight':
        return SizingMode.widthAndHeight;
      case 'widthAndAspectRatio':
        return SizingMode.widthAndAspectRatio;
      case 'heightAndAspectRatio':
        return SizingMode.heightAndAspectRatio;
      default:
        throw Exception("Missing SizingMode for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case SizingMode.widthAndHeight:
        return 'widthAndHeight';
      case SizingMode.widthAndAspectRatio:
        return 'widthAndAspectRatio';
      case SizingMode.heightAndAspectRatio:
        return 'heightAndAspectRatio';
      default:
        throw Exception("Missing Json Value for '$this' sizing mode");
    }
  }
}

class Brush implements Serializable {
  static final Color _transparent = Color(0x00000000);

  final Color _fillColor;
  Color get fillColor => _fillColor;

  final Color _strokeColor;
  Color get strokeColor => _strokeColor;

  final double _strokeWidth;
  double get strokeWidth => _strokeWidth;

  Brush(this._fillColor, this._strokeColor, this._strokeWidth);

  static Brush get transparent => Brush(_transparent, _transparent, 0);

  @override
  Map<String, dynamic> toMap() {
    return {
      'fill': {'color': _fillColor.jsonValue},
      'stroke': {'color': _strokeColor.jsonValue, 'width': _strokeWidth}
    };
  }
}

extension ColorDeserializer on Color {
  String get jsonValue => '#'
          '${red.toRadixString(16).padLeft(2, '0')}'
          '${green.toRadixString(16).padLeft(2, '0')}'
          '${blue.toRadixString(16).padLeft(2, '0')}'
          '${alpha.toRadixString(16).padLeft(2, '0')}'
      .toUpperCase();

  static Color fromRgbaHex(String hex) {
    return Color(int.parse(_toArgb(_normalizeHex(hex)), radix: 16));
  }

  static String _toArgb(String rgba) {
    return rgba.substring(6) + rgba.substring(0, 6);
  }

  static String _normalizeHex(String hex) {
    // remove leading #
    if (hex.startsWith('#')) {
      hex = hex.replaceFirst('#', '');
    }

    // double digits if single digit
    if (hex.length < 6) {
      hex = hex.split('').map((e) => e + e).toList().join('');
    }

    // add alpha if missing
    if (hex.length == 6) {
      hex = '${hex}FF';
    }

    return hex.toUpperCase();
  }
}

enum Orientation { unknown, portrait, portraitUpsideDown, landscapeRight, landscapeLeft }

extension OrientationDeserializer on Orientation {
  static Orientation fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'unknown':
        return Orientation.unknown;
      case 'portrait':
        return Orientation.portrait;
      case 'portraitUpsideDown':
        return Orientation.portraitUpsideDown;
      case 'landscapeRight':
        return Orientation.landscapeRight;
      case 'landscapeLeft':
        return Orientation.landscapeLeft;
      default:
        throw Exception("Missing Orientation for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case Orientation.unknown:
        return 'unknown';
      case Orientation.portrait:
        return 'portrait';
      case Orientation.portraitUpsideDown:
        return 'portraitUpsideDown';
      case Orientation.landscapeRight:
        return 'landscapeRight';
      case Orientation.landscapeLeft:
        return 'landscapeLeft';
      default:
        throw Exception("Missing Json Value for '$this' orientation");
    }
  }
}

@immutable
class Size {
  final double _width;
  double get width => _width;

  final double _height;
  double get height => _height;

  Size(this._width, this._height);

  Size.fromJSON(Map<String, dynamic> json)
      : this((json['width'] as num).toDouble(), (json['height'] as num).toDouble());
}
