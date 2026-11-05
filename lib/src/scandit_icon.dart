/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'common.dart';
import 'map_helper.dart';

/// The icon types.
///
/// Added in version 7.1.0
enum ScanditIconType {
  /// Arrow pointing up.
  ///
  /// Added in version 7.1.0
  arrowUp('arrowUp'),
  /// Arrow pointing down.
  ///
  /// Added in version 7.1.0
  arrowDown('arrowDown'),
  /// Arrow pointing left.
  ///
  /// Added in version 7.1.0
  arrowLeft('arrowLeft'),
  /// Arrow pointing right.
  ///
  /// Added in version 7.1.0
  arrowRight('arrowRight'),
  /// To pick icon.
  ///
  /// Added in version 7.1.0
  toPick('toPick'),
  /// Checkmark icon.
  ///
  /// Added in version 7.1.0
  checkmark('checkmark'),
  /// Chevron pointing up.
  ///
  /// Added in version 7.1.0
  chevronUp('chevronUp'),
  /// Chevron pointing down.
  ///
  /// Added in version 7.1.0
  chevronDown('chevronDown'),
  /// Chevron pointing left.
  ///
  /// Added in version 7.1.0
  chevronLeft('chevronLeft'),
  /// Chevron pointing right.
  ///
  /// Added in version 7.1.0
  chevronRight('chevronRight'),
  /// X icon.
  ///
  /// Added in version 7.1.0
  xMark('xMark'),
  /// Question mark icon.
  ///
  /// Added in version 7.1.0
  questionMark('questionMark'),
  /// Exclamation mark icon.
  ///
  /// Added in version 7.1.0
  exclamationMark('exclamationMark'),
  /// Low stock icon.
  ///
  /// Added in version 7.1.0
  lowStock('lowStock'),
  /// Inspect item icon.
  ///
  /// Added in version 7.1.0
  inspectItem('inspectItem'),
  /// Expired item icon.
  ///
  /// Added in version 7.1.0
  expiredItem('expiredItem'),
  /// Wrong item icon.
  ///
  /// Added in version 7.1.0
  wrongItem('wrongItem'),
  /// Fragile item icon.
  ///
  /// Added in version 7.1.0
  fragileItem('fragileItem'),
  /// Filled star icon.
  ///
  /// Added in version 7.1.0
  starFilled('starFilled'),
  /// Half-filled star icon.
  ///
  /// Added in version 7.1.0
  starHalfFilled('starHalfFilled'),
  /// Outlined Star icon.
  ///
  /// Added in version 7.1.0
  starOutlined('starOutlined'),
  /// Print icon.
  ///
  /// Added in version 7.1.0
  print('print'),
  /// Plus icon.
  ///
  /// Added in version 8.5.0
  plus('plus'),
  /// Horizontal minus icon.
  ///
  /// Added in version 8.5.0
  minus('minus'),
  /// Delete/trash can icon.
  ///
  /// Added in version 8.5.0
  delete('delete'),
  /// Slash icon.
  ///
  /// Added in version 8.5.0
  slash('slash');

  const ScanditIconType(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ScanditIconTypeSerializer on ScanditIconType {
  static ScanditIconType fromJSON(String jsonValue) {
    return ScanditIconType.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// The icon shapes.
///
/// Added in version 7.1.0
enum ScanditIconShape {
  /// Circle shape.
  ///
  /// Added in version 7.1.0
  circle('circle'),
  /// Square shape.
  ///
  /// Added in version 7.1.0
  square('square');

  const ScanditIconShape(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension ScanditIconShapeSerializer on ScanditIconType {
  static ScanditIconShape fromJSON(String jsonValue) {
    return ScanditIconShape.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

/// Class that holds a Scandit icon.
///
/// Added in version 7.1.0
class ScanditIcon implements Serializable {
  ScanditIconType? _iconType;
  Color? _iconColor;
  Color? _backgroundColor;
  Color? _backgroundStrokeColor;
  double _backgroundStrokeWidth = 3.0;
  ScanditIconShape? _backgroundShape;

  ScanditIcon._(
    this._iconType,
    this._iconColor,
    this._backgroundColor,
    this._backgroundStrokeColor,
    this._backgroundStrokeWidth,
    this._backgroundShape,
  );

  /// Constructs a scandit icon builder to build a scandit icon.
  ///
  /// Added in version 7.1.0
  static ScanditIconBuilder builder() {
    return ScanditIconBuilder();
  }

  /// The icon.
  ///
  /// Added in version 7.1.0
  ScanditIconType? get icon => _iconType;

  /// The color of the icon. When not set, the icon is rendered in white.
  ///
  /// Added in version 7.1.0
  Color? get iconColor => _iconColor;

  /// The color applied to the icon’s background.
  ///
  /// Added in version 7.1.0
  Color? get backgroundColor => _backgroundColor;

  /// The color of the stroke applied to the icon’s background.
  ///
  /// Added in version 7.1.0
  Color? get backgroundStrokeColor => _backgroundStrokeColor;

  /// The width of the stroke applied to the icon’s background.
  ///
  /// Added in version 7.1.0
  double get backgroundStrokeWidth => _backgroundStrokeWidth;

  /// The icon’s background shape.
  ///
  /// Added in version 7.1.0
  ScanditIconShape? get backgroundShape => _backgroundShape;

  factory ScanditIcon.fromJSON(Map<String, dynamic> json) {
    ScanditIconType? icon;
    if (json['icon'] != null) {
      icon = ScanditIconTypeSerializer.fromJSON(json['icon']);
    }
    Color? iconColor = parseColor(json, 'iconColor');
    Color? backgroundColor = parseColor(json, 'backgroundColor');
    Color? backgroundStrokeColor = parseColor(json, 'backgroundStrokeColor');
    double backgroundStrokeWidth = parseDouble(json, 'backgroundStrokeWidth') ?? 3.0;
    ScanditIconShape? backgroundShape;
    if (json['backgroundShape'] != null) {
      backgroundShape = ScanditIconShapeSerializer.fromJSON(json['backgroundShape']);
    }
    return ScanditIcon._(
      icon,
      iconColor,
      backgroundColor,
      backgroundStrokeColor,
      backgroundStrokeWidth,
      backgroundShape,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'icon': _iconType.toString(),
      'iconColor': _iconColor?.jsonValue,
      'backgroundColor': _backgroundColor?.jsonValue,
      'backgroundStrokeColor': _backgroundStrokeColor?.jsonValue,
      'backgroundStrokeWidth': _backgroundStrokeWidth,
      'backgroundShape': _backgroundShape?.toString(),
    };
  }
}

/// Use this object to construct instances of [ScanditIcon].
///
/// Added in version 7.1.0
class ScanditIconBuilder {
  ScanditIconType? _iconType;
  Color? _iconColor;
  Color? _backgroundColor;
  Color? _backgroundStrokeColor;
  double _backgroundStrokeWidth = 3.0;
  ScanditIconShape? _backgroundShape;

  /// Sets the icon.
  ///
  /// Added in version 7.1.0
  ScanditIconBuilder withIcon(ScanditIconType? iconType) {
    _iconType = iconType;
    return this;
  }

  /// Sets the color of the icon.
  ///
  /// Added in version 7.1.0
  ScanditIconBuilder withIconColor(Color? iconColor) {
    _iconColor = iconColor;
    return this;
  }

  /// Sets the color applied to the icon’s background.
  ///
  /// Added in version 7.1.0
  ScanditIconBuilder withBackgroundColor(Color? backgroundColor) {
    _backgroundColor = backgroundColor;
    return this;
  }

  /// Sets the color of the stroke applied to the icon’s background.
  ///
  /// Added in version 7.1.0
  ScanditIconBuilder withBackgroundStrokeColor(Color? backgroundStrokeColor) {
    _backgroundStrokeColor = backgroundStrokeColor;
    return this;
  }

  /// Sets the width of the stroke applied to the icon’s background.
  ///
  /// Added in version 7.1.0
  ScanditIconBuilder withBackgroundStrokeWidth(double backgroundStrokeWidth) {
    _backgroundStrokeWidth = backgroundStrokeWidth;
    return this;
  }

  /// Sets the icon’s background shape.
  ///
  /// Added in version 7.1.0
  ScanditIconBuilder withBackgroundShape(ScanditIconShape? backgroundShape) {
    _backgroundShape = backgroundShape;
    return this;
  }

  /// Constructs a [ScanditIcon] with the properties set on the builder.
  ///
  /// Added in version 7.1.0
  ScanditIcon build() {
    return ScanditIcon._(
      _iconType,
      _iconColor,
      _backgroundColor,
      _backgroundStrokeColor,
      _backgroundStrokeWidth,
      _backgroundShape,
    );
  }
}
