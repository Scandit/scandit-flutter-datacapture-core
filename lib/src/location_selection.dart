/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'common.dart';

abstract class LocationSelection implements Serializable {
  final String _type;
  LocationSelection._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

class RadiusLocationSelection extends LocationSelection {
  final DoubleWithUnit _radius;
  DoubleWithUnit get radius => _radius;

  RadiusLocationSelection(this._radius) : super._('radius');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['radius'] = radius.toMap();
    return json;
  }
}

class RectangularLocationSelection extends LocationSelection {
  final SizeWithUnitAndAspect _sizeWithUnitAndAspect;
  SizeWithUnitAndAspect get sizeWithUnitAndAspect => _sizeWithUnitAndAspect;

  RectangularLocationSelection._(this._sizeWithUnitAndAspect) : super._('rectangular');

  RectangularLocationSelection.withSize(SizeWithUnit size) : this._(SizeWithUnitAndAspect.widthAndHeight(size));

  RectangularLocationSelection.withWidthAndAspect(DoubleWithUnit width, double aspectRatio)
      : this._(SizeWithUnitAndAspect.widthAndAspectRatio(width, aspectRatio));

  RectangularLocationSelection.withHeightAndAspect(DoubleWithUnit height, double aspectRatio)
      : this._(SizeWithUnitAndAspect.heightAndAspectRatio(height, aspectRatio));

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['size'] = _sizeWithUnitAndAspect.toMap();
    return json;
  }
}
