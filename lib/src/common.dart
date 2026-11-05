/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/src/internal/generated/schema_types.dart'
    show buildMarginsWithUnit, buildQuadrilateral, buildRect, buildUIPoint;

abstract class Serializable {
  Map<String, dynamic> toMap();
}

/// Holds margin values (left, top, right, bottom) that can each be expressed with a different measure unit.
///
/// Added in version 6.7.0
@immutable
class MarginsWithUnit implements Serializable {
  /// Left margin.
  ///
  /// Added in version 6.7.0
  final DoubleWithUnit left;
  /// Top margin.
  ///
  /// Added in version 6.7.0
  final DoubleWithUnit top;
  /// Right margin.
  ///
  /// Added in version 6.7.0
  final DoubleWithUnit right;
  /// Bottom margin.
  ///
  /// Added in version 6.7.0
  final DoubleWithUnit bottom;

  /// Constructs a new MarginsWithUnit instance.
  ///
  /// Added in version 6.7.0
  const MarginsWithUnit(this.left, this.top, this.right, this.bottom);

  MarginsWithUnit.fromJSON(Map<String, dynamic> json)
      : this(
            DoubleWithUnit.fromJSON(json['left'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['top'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['right'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['bottom'] as Map<String, dynamic>));

  @override
  Map<String, dynamic> toMap() {
    return buildMarginsWithUnit(
      left: left.toMap(),
      right: right.toMap(),
      top: top.toMap(),
      bottom: bottom.toMap(),
    );
  }
}

/// Added in version 6.7.0
@immutable
class PointWithUnit implements Serializable {
  /// X coordinate of the point.
  ///
  /// Added in version 6.7.0
  final DoubleWithUnit x;
  /// Y coordinate of the point.
  ///
  /// Added in version 6.7.0
  final DoubleWithUnit y;

  /// Returns a PointWithUnit with value set to 0.0f.
  ///
  /// Added in version 8.5.0
  static PointWithUnit get zero => PointWithUnit(DoubleWithUnit.zero, DoubleWithUnit.zero);

  /// Constructs a new point at position *x* and *y*.
  ///
  /// Added in version 6.7.0
  const PointWithUnit(this.x, this.y);

  PointWithUnit.fromJSON(Map<String, dynamic> json)
      : this(DoubleWithUnit.fromJSON(json['x'] as Map<String, dynamic>),
            DoubleWithUnit.fromJSON(json['y'] as Map<String, dynamic>));

  @override
  Map<String, dynamic> toMap() {
    return {'x': x.toMap(), 'y': y.toMap()};
  }
}

/// Holds a floating-point value plus a measure unit.
///
/// Added in version 6.7.0
@immutable
class DoubleWithUnit implements Serializable {
  /// Added in version 6.7.0
  final double value;
  /// Added in version 6.7.0
  final MeasureUnit unit;

  /// Returns a FloatWithUnit with value set to 0.0f.
  ///
  /// Added in version 8.5.0
  static DoubleWithUnit get zero => const DoubleWithUnit(0.0, MeasureUnit.fraction);

  /// Constructs a new float with unit.
  ///
  /// Added in version 6.7.0
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

/// Specifies in what units the value has been specified (fraction, device-independent pixels, pixels).
///
/// Added in version 6.7.0
enum MeasureUnit {
  /// Value is measured in device-independent pixels.
  ///
  /// Added in version 6.7.0
  dip('dip'),
  /// Value is measured in pixels.
  ///
  /// Added in version 6.7.0
  pixel('pixel'),
  /// Value is measured as a fraction. Valid values range from 0 to 1. This can be used to specify values in relative coordinates with respect to a reference, e.g. the view width or height.
  ///
  /// Added in version 6.7.0
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

/// An enumeration of possible anchoring points in a geometric object such as quadrilaterals ([Quadrilateral]). Values of this enumeration are typically used to determine where elements are placed on the screen. For example, it is used to place the logo on screen.
///
/// Added in version 6.7.0
enum Anchor {
  /// This value will use the top left corner as the anchor point.
  ///
  /// Added in version 6.7.0
  topLeft('topLeft'),
  /// This value will will use the center of the top edge as the anchor point.
  ///
  /// Added in version 6.7.0
  topCenter('topCenter'),
  /// This value will use the top right corner as the anchor point.
  ///
  /// Added in version 6.7.0
  topRight('topRight'),
  /// This value will use the center left corner as the anchor point.
  ///
  /// Added in version 6.7.0
  centerLeft('centerLeft'),
  /// This value will use the center as the anchor point.
  ///
  /// Added in version 6.7.0
  center('center'),
  /// This value will use the center of the right edge as the anchor point.
  ///
  /// Added in version 6.7.0
  centerRight('centerRight'),
  /// This value will use the bottom left corner as the anchor point.
  ///
  /// Added in version 6.7.0
  bottomLeft('bottomLeft'),
  /// This value will use the center of the bottom edge as the anchor point.
  ///
  /// Added in version 6.7.0
  bottomCenter('bottomCenter'),
  /// This value will use the bottom right corner as the anchor point.
  ///
  /// Added in version 6.7.0
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

/// Added in version 6.7.0
@immutable
class Point implements Serializable {
  final double _x;
  /// X coordinate of the point.
  ///
  /// Added in version 6.7.0
  double get x => _x;

  final double _y;
  /// Y coordinate of the point.
  ///
  /// Added in version 6.7.0
  double get y => _y;

  /// Constructs a new point at position *x* and *y*.
  ///
  /// Added in version 6.7.0
  const Point(this._x, this._y);

  Point.fromJSON(Map<String, dynamic> json) : this((json['x'] as num).toDouble(), (json['y'] as num).toDouble());

  @override
  Map<String, dynamic> toMap() {
    return buildUIPoint(
      x: _x,
      y: _y,
    );
  }
}

/// Polygon represented by 4 corners.
///
/// Added in version 6.7.0
@immutable
class Quadrilateral implements Serializable {
  final Point _topLeft;
  /// Added in version 6.7.0
  Point get topLeft => _topLeft;

  final Point _topRight;
  /// Added in version 6.7.0
  Point get topRight => _topRight;

  final Point _bottomRight;
  /// Added in version 6.7.0
  Point get bottomRight => _bottomRight;

  final Point _bottomLeft;
  /// Added in version 6.7.0
  Point get bottomLeft => _bottomLeft;

  /// Constructs a new Quadrilateral instance.
  ///
  /// Added in version 6.7.0
  const Quadrilateral(this._topLeft, this._topRight, this._bottomRight, this._bottomLeft);

  Quadrilateral.fromJSON(Map<String, dynamic> json)
      : this(Point.fromJSON(json['topLeft']), Point.fromJSON(json['topRight']), Point.fromJSON(json['bottomRight']),
            Point.fromJSON(json['bottomLeft']));

  @override
  Map<String, dynamic> toMap() {
    return buildQuadrilateral(
      topLeft: _topLeft.toMap(),
      topRight: _topRight.toMap(),
      bottomRight: _bottomRight.toMap(),
      bottomLeft: _bottomLeft.toMap(),
    );
  }
}

/// Indicates whether the code is part of a composite code.
///
/// Added in version 6.7.0
enum CompositeFlag {
  /// Code is not part of a composite code.
  ///
  /// Added in version 6.7.0
  none('none'),
  /// Code could be part of a composite code. This flag is set by linear (1d) symbologies that have no composite flag support but can be part of a composite code like the EAN/UPC symbology family.
  ///
  /// Added in version 6.7.0
  unknown('unknown'),
  /// Code is the linear component of a composite code. This flag can be set by GS1 DataBar ([Symbology.gs1Databar]) or GS1-128 (Code 128 ([Symbology.code128])).
  ///
  /// Added in version 6.7.0
  linked('linked'),
  /// Code is a GS1 Composite Code Type A (CC-A). This flag can be set by [Symbology.microPdf417] codes.
  ///
  /// Added in version 6.7.0
  gs1TypeA('gs1TypeA'),
  /// Code is a GS1 Composite Code Type B (CC-B). This flag can be set by [Symbology.microPdf417] codes.
  ///
  /// Added in version 6.7.0
  gs1TypeB('gs1TypeB'),
  /// Code is a GS1 Composite Code Type C (CC-C). This flag can be set by [Symbology.pdf417] codes.
  ///
  /// Added in version 6.7.0
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

/// Holds a [SizingMode] - and corresponding required values - to define a rectangular size.
///
/// Added in version 6.7.0
class SizeWithUnitAndAspect implements Serializable {
  SizeWithUnit? _widthAndHeight;
  /// The values for width and height.
  ///
  /// This value will always be *null* unless [SizeWithUnitAndAspect.sizingMode] is [SizingMode.widthAndHeight].
  ///
  /// Added in version 6.7.0
  SizeWithUnit? get widthAndHeight => _widthAndHeight;

  SizeWithAspect? _widthAndAspectRatio;
  /// The value for width and the aspect ratio for height.
  ///
  /// This value will always be *null* unless [SizeWithUnitAndAspect.sizingMode] is [SizingMode.widthAndAspectRatio].
  ///
  /// Added in version 6.7.0
  SizeWithAspect? get widthAndAspectRatio => _widthAndAspectRatio;

  SizeWithAspect? _heightAndAspectRatio;
  /// The value for height and the aspect ratio for width.
  ///
  /// This value will always be *null* unless [SizeWithUnitAndAspect.sizingMode] is [SizingMode.heightAndAspectRatio].
  ///
  /// Added in version 6.7.0
  SizeWithAspect? get heightAndAspectRatio => _heightAndAspectRatio;

  SizeWithAspect? _shorterDimensionAndAspectRatio;
  /// The value for the short dimension of the reference view and the aspect ratio for the long dimension of the reference view.
  ///
  /// This value will always be *null* unless [SizeWithUnitAndAspect.sizingMode] is [SizingMode.shorterDimensionAndAspectRatio].
  ///
  /// Added in version 6.8.0
  SizeWithAspect? get shorterDimensionAndAspectRatio => _shorterDimensionAndAspectRatio;

  /// The sizing mode.
  ///
  /// Added in version 6.7.0
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

  /// Creates a rectangular size based on the given shorter dimension and aspect ratio.
  ///
  /// Added in version 6.8.0
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

/// Added in version 6.7.0
@immutable
class SizeWithUnit implements Serializable {
  final DoubleWithUnit _width;
  /// The width.
  ///
  /// Added in version 6.7.0
  DoubleWithUnit get width => _width;

  final DoubleWithUnit _height;
  /// The height.
  ///
  /// Added in version 6.7.0
  DoubleWithUnit get height => _height;

  /// Returns a SizeWithUnit with value set to 0.0f.
  ///
  /// Added in version 8.5.0
  static SizeWithUnit get zero => SizeWithUnit(DoubleWithUnit.zero, DoubleWithUnit.zero);

  /// Constructs a new size with unit.
  ///
  /// Added in version 6.7.0
  const SizeWithUnit(this._width, this._height);

  SizeWithUnit.fromJSON(Map<String, dynamic> json)
      : this(DoubleWithUnit.fromJSON(json['width']), DoubleWithUnit.fromJSON(json['height']));

  @override
  Map<String, dynamic> toMap() {
    return {'width': _width.toMap(), 'height': _height.toMap()};
  }
}

/// Holds values to define a rectangular size using a dimension and an aspect ratio multiplier.
///
/// Added in version 6.7.0
@immutable
class SizeWithAspect implements Serializable {
  final DoubleWithUnit _size;
  /// The size of one dimension.
  ///
  /// Added in version 6.7.0
  DoubleWithUnit get size => _size;

  final double _aspect;
  /// The aspect ratio for the other dimension.
  ///
  /// Added in version 6.7.0
  double get aspect => _aspect;

  /// Returns a SizeWithAspect with value set to 0.0f.
  ///
  /// Added in version 8.5.0
  static SizeWithAspect get zero => SizeWithAspect(DoubleWithUnit.zero, 0.0);

  /// Constructs a new size with aspect.
  ///
  /// Added in version 6.7.0
  const SizeWithAspect(this._size, this._aspect);

  SizeWithAspect.fromJSON(Map<String, dynamic> json)
      : this(DoubleWithUnit.fromJSON(json['size']), (json['aspect'] as num).toDouble());

  @override
  Map<String, dynamic> toMap() {
    return {'size': _size.toMap(), 'aspect': aspect};
  }
}

/// An enumeration of possible ways to define a rectangular size.
///
/// Added in version 6.7.0
enum SizingMode {
  /// This value will use a [SizeWithUnit] to determine width and the height.
  ///
  /// Added in version 6.7.0
  widthAndHeight('widthAndHeight'),
  /// This value will use a DoubleWithUnit ([FloatWithUnit]) to determine the width and a float multiplier to determine the height.
  ///
  /// Added in version 6.7.0
  widthAndAspectRatio('widthAndAspectRatio'),
  /// This value will use a DoubleWithUnit ([FloatWithUnit]) to determine the height and a float multiplier to determine the width.
  ///
  /// Added in version 6.7.0
  heightAndAspectRatio('heightAndAspectRatio'),
  /// This value will use a DoubleWithUnit ([FloatWithUnit]) to determine the rectangle length on the short side of the reference and a float multiplier to determine the length on the long side.
  ///
  /// Added in version 6.8.0
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

/// Brushes define how objects are drawn on screen and allow to change their fill and stroke color as well as the stroke width. They are, for example, used to change the styling of barcode locations, or other objects drawn on top of the video preview. Brushes are immutable. Once created none of the members can be modified.
///
/// Added in version 6.7.0
class Brush implements Serializable {
  static const Color _transparent = Color(0x00000000);

  final Color _fillColor;
  /// The fill color used to draw the object.
  ///
  /// Added in version 6.7.0
  Color get fillColor => _fillColor;

  final Color _strokeColor;
  /// The stroke color used to draw the object.
  ///
  /// Added in version 6.7.0
  Color get strokeColor => _strokeColor;

  final double _strokeWidth;
  /// The width in device-independent pixels used to render the stroke.
  ///
  /// Added in version 6.7.0
  double get strokeWidth => _strokeWidth;

  /// Creates a new default brush. Both fill and stroke color are set to fully transparent black. The stroke width is set to zero.
  ///
  /// Added in version 8.5.0
  Brush(this._fillColor, this._strokeColor, this._strokeWidth);

  Brush.defaultBrush() : this(_transparent, _transparent, 0);

  /// Creates a new brush where both fill and stroke colors are set to fully transparent black. The stroke width is set to zero.
  ///
  /// Added in version 6.7.0
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

/// Added in version 6.7.0
enum Orientation {
  /// Added in version 6.7.0
  unknown('unknown'),
  /// Added in version 6.7.0
  portrait('portrait'),
  /// Added in version 6.7.0
  portraitUpsideDown('portraitUpsideDown'),
  /// Added in version 6.7.0
  landscapeRight('landscapeRight'),
  /// Added in version 6.7.0
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

/// Added in version 6.7.0
@immutable
class Size implements Serializable {
  final double _width;
  /// The width.
  ///
  /// Added in version 6.7.0
  double get width => _width;

  final double _height;
  /// The height.
  ///
  /// Added in version 6.7.0
  double get height => _height;

  /// Added in version 6.7.0
  const Size(this._width, this._height);

  Size.fromJSON(Map<String, dynamic> json)
      : this(json.containsKey('width') ? (json['width'] as num).toDouble() : throw ArgumentError('width'),
            json.containsKey('height') ? (json['height'] as num).toDouble() : throw ArgumentError('height'));

  @override
  Map<String, dynamic> toMap() {
    return {'width': _width, 'height': _height};
  }
}

/// Added in version 7.2.0
@immutable
class Rect implements Serializable {
  final Point _origin;
  /// The origin (top-left corner) of the rectangle.
  ///
  /// Added in version 7.2.0
  Point get origin => _origin;

  final Size _size;
  /// The size of the rectangle.
  ///
  /// Added in version 7.2.0
  Size get size => _size;

  /// Constructs a new rectangle.
  ///
  /// Added in version 7.2.0
  const Rect(this._origin, this._size);

  Rect.fromJSON(Map<String, dynamic> json) : this(Point.fromJSON(json['origin']), Size.fromJSON(json['size']));

  @override
  Map<String, dynamic> toMap() {
    return buildRect(
      origin: _origin.toMap(),
      size: _size.toMap(),
    );
  }
}
