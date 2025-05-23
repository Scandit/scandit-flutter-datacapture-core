/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract class Serializable {
  Map<String, dynamic> toMap();
}

@immutable
class MarginsWithUnit implements Serializable {
  final DoubleWithUnit left;
  final DoubleWithUnit top;
  final DoubleWithUnit right;
  final DoubleWithUnit bottom;

  const MarginsWithUnit(this.left, this.top, this.right, this.bottom);

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

  const PointWithUnit(this.x, this.y);

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

  static DoubleWithUnit get zero => const DoubleWithUnit(0.0, MeasureUnit.fraction);

  const DoubleWithUnit(this.value, this.unit);

  DoubleWithUnit.fromJSON(Map<String, dynamic> json)
      : this(
            (json.containsKey('value') ? json['value'] as num : throw ArgumentError('json does not containe value'))
                .toDouble(),
            MesaureUnitDeserializer.fromJSON(json['unit'] as String?));

  @override
  Map<String, dynamic> toMap() {
    return {'value': value, 'unit': unit.toString()};
  }
}

enum MeasureUnit {
  dip('dip'),
  pixel('pixel'),
  fraction('fraction');

  const MeasureUnit(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension MesaureUnitDeserializer on MeasureUnit {
  static MeasureUnit fromJSON(String? jsonValue) {
    return MeasureUnit.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

enum Anchor {
  topLeft('topLeft'),
  topCenter('topCenter'),
  topRight('topRight'),
  centerLeft('centerLeft'),
  center('center'),
  centerRight('centerRight'),
  bottomLeft('bottomLeft'),
  bottomCenter('bottomCenter'),
  bottomRight('bottomRight');

  const Anchor(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension AnchorDeserializer on Anchor {
  static Anchor fromJSON(String jsonValue) {
    return Anchor.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

@immutable
class Point implements Serializable {
  final double _x;
  double get x => _x;

  final double _y;
  double get y => _y;

  const Point(this._x, this._y);

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

  const Quadrilateral(this._topLeft, this._topRight, this._bottomRight, this._bottomLeft);

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

enum CompositeFlag {
  none('none'),
  unknown('unknown'),
  linked('linked'),
  gs1TypeA('gs1TypeA'),
  gs1TypeB('gs1TypeB'),
  gs1TypeC('gs1TypeC');

  const CompositeFlag(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension CompositeFlagDeserializer on CompositeFlag {
  static CompositeFlag fromJSON(String jsonValue) {
    return CompositeFlag.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class SizeWithUnitAndAspect implements Serializable {
  SizeWithUnit? _widthAndHeight;
  SizeWithUnit? get widthAndHeight => _widthAndHeight;

  SizeWithAspect? _widthAndAspectRatio;
  SizeWithAspect? get widthAndAspectRatio => _widthAndAspectRatio;

  SizeWithAspect? _heightAndAspectRatio;
  SizeWithAspect? get heightAndAspectRatio => _heightAndAspectRatio;

  SizeWithAspect? _shorterDimensionAndAspectRatio;
  SizeWithAspect? get shorterDimensionAndAspectRatio => _shorterDimensionAndAspectRatio;

  SizingMode get sizingMode => _sizingMode();

  SizingMode _sizingMode() {
    if (_widthAndAspectRatio != null) {
      return SizingMode.widthAndAspectRatio;
    }
    if (_heightAndAspectRatio != null) {
      return SizingMode.heightAndAspectRatio;
    }
    if (_shorterDimensionAndAspectRatio != null) {
      return SizingMode.shorterDimensionAndAspectRatio;
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

  SizeWithUnitAndAspect.shorterDimensionAndAspectRatio(double fraction, double aspectRatio) {
    _shorterDimensionAndAspectRatio = SizeWithAspect(DoubleWithUnit(fraction, MeasureUnit.fraction), aspectRatio);
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
    } else if (json.containsKey('shorterDimension') && json.containsKey('aspect')) {
      return SizeWithUnitAndAspect.shorterDimensionAndAspectRatio(
          (json['shorterDimension']['value'] as num).toDouble(), (json['aspect'] as num).toDouble());
    }
    throw Exception("Unable to create an instance of SizeWithUnitAndAspect from the given json");
  }

  @override
  Map<String, dynamic> toMap() {
    if (_widthAndAspectRatio != null) {
      return {'width': _widthAndAspectRatio?.size.toMap(), 'aspect': _widthAndAspectRatio?.aspect};
    }
    if (_heightAndAspectRatio != null) {
      return {'height': _heightAndAspectRatio?.size.toMap(), 'aspect': _heightAndAspectRatio?.aspect};
    }
    if (_shorterDimensionAndAspectRatio != null) {
      return {
        'shorterDimension': _shorterDimensionAndAspectRatio?.size.toMap(),
        'aspect': _shorterDimensionAndAspectRatio?.aspect
      };
    }
    return _widthAndHeight != null ? _widthAndHeight!.toMap() : {};
  }
}

@immutable
class SizeWithUnit implements Serializable {
  final DoubleWithUnit _width;
  DoubleWithUnit get width => _width;

  final DoubleWithUnit _height;
  DoubleWithUnit get height => _height;

  const SizeWithUnit(this._width, this._height);

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

  const SizeWithAspect(this._size, this._aspect);

  SizeWithAspect.fromJSON(Map<String, dynamic> json)
      : this(DoubleWithUnit.fromJSON(json['size']), (json['aspect'] as num).toDouble());

  @override
  Map<String, dynamic> toMap() {
    return {'size': _size.toMap(), 'aspect': aspect};
  }
}

enum SizingMode {
  widthAndHeight('widthAndHeight'),
  widthAndAspectRatio('widthAndAspectRatio'),
  heightAndAspectRatio('heightAndAspectRatio'),
  shorterDimensionAndAspectRatio('shorterDimensionAndAspectRatio');

  const SizingMode(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SizingModeDeserializer on SizingMode {
  static SizingMode fromJSON(String jsonValue) {
    return SizingMode.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class Brush implements Serializable {
  static const Color _transparent = Color(0x00000000);

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
          // ignore: deprecated_member_use
          '${red.toRadixString(16).padLeft(2, '0')}'
          // ignore: deprecated_member_use
          '${green.toRadixString(16).padLeft(2, '0')}'
          // ignore: deprecated_member_use
          '${blue.toRadixString(16).padLeft(2, '0')}'
          // ignore: deprecated_member_use
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

enum Orientation {
  unknown('unknown'),
  portrait('portrait'),
  portraitUpsideDown('portraitUpsideDown'),
  landscapeRight('landscapeRight'),
  landscapeLeft('landscapeLeft');

  const Orientation(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension OrientationDeserializer on Orientation {
  static Orientation fromJSON(String jsonValue) {
    return Orientation.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

@immutable
class Size implements Serializable {
  final double _width;
  double get width => _width;

  final double _height;
  double get height => _height;

  const Size(this._width, this._height);

  Size.fromJSON(Map<String, dynamic> json)
      : this(json.containsKey('width') ? (json['width'] as num).toDouble() : throw ArgumentError('width'),
            json.containsKey('height') ? (json['height'] as num).toDouble() : throw ArgumentError('height'));

  @override
  Map<String, dynamic> toMap() {
    return {'width': _width, 'height': _height};
  }
}

@immutable
class Rect implements Serializable {
  final Point _origin;
  Point get origin => _origin;

  final Size _size;
  Size get size => _size;

  const Rect(this._origin, this._size);

  Rect.fromJSON(Map<String, dynamic> json) : this(Point.fromJSON(json['origin']), Size.fromJSON(json['size']));

  @override
  Map<String, dynamic> toMap() {
    return {
      'origin': _origin.toMap(),
      'size': _size.toMap(),
    };
  }
}
