/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'common.dart';
import 'map_helper.dart';

enum ScanditIconType {
  arrowUp('arrowUp'),
  arrowDown('arrowDown'),
  arrowLeft('arrowLeft'),
  arrowRight('arrowRight'),
  toPick('toPick'),
  checkmark('checkmark'),
  chevronUp('chevronUp'),
  chevronDown('chevronDown'),
  chevronLeft('chevronLeft'),
  chevronRight('chevronRight'),
  xMark('xMark'),
  questionMark('questionMark'),
  exclamationMark('exclamationMark'),
  lowStock('lowStock'),
  inspectItem('inspectItem'),
  expiredItem('expiredItem'),
  wrongItem('wrongItem'),
  fragileItem('fragileItem'),
  starFilled('starFilled'),
  starHalfFilled('starHalfFilled'),
  starOutlined('starOutlined'),
  print('print');

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

enum ScanditIconShape {
  circle('circle'),
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

  static ScanditIconBuilder builder() {
    return ScanditIconBuilder();
  }

  ScanditIconType? get icon => _iconType;

  Color? get iconColor => _iconColor;

  Color? get backgroundColor => _backgroundColor;

  Color? get backgroundStrokeColor => _backgroundStrokeColor;

  double get backgroundStrokeWidth => _backgroundStrokeWidth;

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

class ScanditIconBuilder {
  ScanditIconType? _iconType;
  Color? _iconColor;
  Color? _backgroundColor;
  Color? _backgroundStrokeColor;
  double _backgroundStrokeWidth = 3.0;
  ScanditIconShape? _backgroundShape;

  ScanditIconBuilder withIcon(ScanditIconType? iconType) {
    _iconType = iconType;
    return this;
  }

  ScanditIconBuilder withIconColor(Color? iconColor) {
    _iconColor = iconColor;
    return this;
  }

  ScanditIconBuilder withBackgroundColor(Color? backgroundColor) {
    _backgroundColor = backgroundColor;
    return this;
  }

  ScanditIconBuilder withBackgroundStrokeColor(Color? backgroundStrokeColor) {
    _backgroundStrokeColor = backgroundStrokeColor;
    return this;
  }

  ScanditIconBuilder withBackgroundStrokeWidth(double backgroundStrokeWidth) {
    _backgroundStrokeWidth = backgroundStrokeWidth;
    return this;
  }

  ScanditIconBuilder withBackgroundShape(ScanditIconShape? backgroundShape) {
    _backgroundShape = backgroundShape;
    return this;
  }

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
