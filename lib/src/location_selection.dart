/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'common.dart';

/// Interface for location selection. Location selections implement a specific strategy how a data object (like a barcode or text) is selected out of multiple visible ones by for example only selecting objects inside a certain area or objects that intersect a certain area. Implementations are provided by [RadiusLocationSelection] and [RectangularLocationSelection].
///
/// Location selection implementations are restricted to the set of location selections provided by the Scandit Data Capture SDK, it is not possible to implement this interface with a custom implementations of location selection. This interface does not expose any methods or properties, it just serves as a unifying type for different selection strategies.
///
/// Added in version 6.7.0
abstract class LocationSelection implements Serializable {
  final String _type;
  LocationSelection._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

/// Location selection for selecting codes inside a circle with the given radius, centered on the point of interest ([DataCaptureView.pointOfInterest]). Any object that touches the circle is returned, objects that do not intersect the circle are filtered out.
///
/// Added in version 6.7.0
class RadiusLocationSelection extends LocationSelection {
  final DoubleWithUnit _radius;
  /// The radius of the circle. When using fractional coordinates, the radius is measured relative to the view’s width.
  ///
  /// Added in version 6.7.0
  DoubleWithUnit get radius => _radius;

  /// Creates a new radius location selection instance with the specified radius.
  ///
  /// Added in version 6.7.0
  RadiusLocationSelection(this._radius) : super._('radius');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['radius'] = radius.toMap();
    return json;
  }
}

/// Location selection for selecting codes inside a rectangle centered on the point of interest ([DataCaptureView.pointOfInterest]). Any object that is fully inside the rectangle is returned, objects that are partially or entirely outside of the rectangle are filtered out.
///
/// Added in version 6.7.0
class RectangularLocationSelection extends LocationSelection {
  final SizeWithUnitAndAspect _sizeWithUnitAndAspect;
  /// The size and sizing mode of the location selection.
  ///
  /// Added in version 6.7.0
  SizeWithUnitAndAspect get sizeWithUnitAndAspect => _sizeWithUnitAndAspect;

  RectangularLocationSelection._(this._sizeWithUnitAndAspect) : super._('rectangular');

  RectangularLocationSelection.withSize(SizeWithUnit size) : this._(SizeWithUnitAndAspect.widthAndHeight(size));

  RectangularLocationSelection.withWidthAndAspect(DoubleWithUnit width, double aspectRatio)
      : this._(SizeWithUnitAndAspect.widthAndAspectRatio(width, aspectRatio));

  /// Creates a new rectangular location selection instance with the specified height and computes the width based on the provided width/height aspect ratio. When the unit is relative ([MeasureUnit.fraction]), the height is computed relative to the view size minus the scan area margins.
  ///
  /// Added in version 6.7.0
  RectangularLocationSelection.withHeightAndAspect(DoubleWithUnit height, double aspectRatio)
      : this._(SizeWithUnitAndAspect.heightAndAspectRatio(height, aspectRatio));

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json['size'] = _sizeWithUnitAndAspect.toMap();
    return json;
  }
}
