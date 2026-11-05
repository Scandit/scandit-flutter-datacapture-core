/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../src/common.dart';
import '../src/defaults.dart';

/// Interface for viewfinders. Viewfinders are restricted to the set of viewfinders provided by the Scandit Data Capture SDK, it is not possible for customers to implement this interface and provide custom viewfinder implementations. This interface does not expose any methods or properties, it just serves as a tag for different viewfinder styles.
///
/// Possible viewfinders are:
///
/// - [AimerViewfinder]
/// - [RectangularViewfinder]
/// - [LaserlineViewfinder]
///
/// Added in version 6.7.0
abstract class Viewfinder with ChangeNotifier implements Serializable {
  final String _type;

  Viewfinder(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

/// Rectangular viewfinder with an embedded Scandit logo. The rectangle is always centered on the point of interest ([DataCaptureView.pointOfInterest]) of the view.
///
/// The rectangular viewfinder is displayed when the recognition is active and hidden when it is not.
///
/// To use this viewfinder, create a new instance and assign it to the overlay, e.g. the barcode capture overlay via the [BarcodeCaptureOverlay.viewfinder] property.
///
/// Added in version 6.7.0
class RectangularViewfinder extends Viewfinder {
  SizeWithUnitAndAspect _sizeWithUnitAndAspect;
  /// The size and sizing mode of the viewfinder.
  ///
  /// Added in version 6.7.0
  SizeWithUnitAndAspect get sizeWithUnitAndAspect => _sizeWithUnitAndAspect;

  Color _color;
  /// The color used to draw the logo and viewfinder when the mode is enabled. The color is always used at full opacity, changing the alpha value has no effect.
  ///
  /// Added in version 6.7.0
  Color get color => _color;
  /// The color used to draw the logo and viewfinder when the mode is enabled. The color is always used at full opacity, changing the alpha value has no effect.
  ///
  /// Added in version 6.7.0
  set color(Color newValue) {
    _color = newValue;
    notifyListeners();
  }

  Color _disabledColor;
  /// The color used to draw the logo and viewfinder when the mode is disabled. By default transparent.
  ///
  /// Added in version 6.12.0
  Color get disabledColor => _disabledColor;
  /// The color used to draw the logo and viewfinder when the mode is disabled. By default transparent.
  ///
  /// Added in version 6.12.0
  set disabledColor(Color newValue) {
    _disabledColor = newValue;
    notifyListeners();
  }

  RectangularViewfinderAnimation? _animation;
  /// The animation used for the viewfinder, if any.
  ///
  /// Added in version 6.8.0
  RectangularViewfinderAnimation? get animation => _animation;
  /// The animation used for the viewfinder, if any.
  ///
  /// Added in version 6.8.0
  set animation(RectangularViewfinderAnimation? newValue) {
    _animation = newValue;
    notifyListeners();
  }

  RectangularViewfinderStyle _style;
  /// The style of the viewfinder.
  ///
  /// Added in version 6.8.0
  RectangularViewfinderStyle get style => _style;

  double _dimming;
  /// The amount the area outside the viewfinder’s rectangle is dimmed by. Accepts values between 0 (no dimming) and 1 (fully blacked out).
  ///
  /// Added in version 6.8.0
  double get dimming => _dimming;
  /// The amount the area outside the viewfinder’s rectangle is dimmed by. Accepts values between 0 (no dimming) and 1 (fully blacked out).
  ///
  /// Added in version 6.8.0
  set dimming(double newValue) {
    _dimming = newValue;
    notifyListeners();
  }

  double _disabledDimming;
  /// The amount the area outside the viewfinder’s rectangle is dimmed by when the mode is disabled. Accepts values between 0 (no dimming) and 1 (fully blacked out).
  ///
  /// Added in version 6.11.0
  double get disabledDimming => _disabledDimming;
  /// The amount the area outside the viewfinder’s rectangle is dimmed by when the mode is disabled. Accepts values between 0 (no dimming) and 1 (fully blacked out).
  ///
  /// Added in version 6.11.0
  set disabledDimming(double newValue) {
    _disabledDimming = newValue;
    notifyListeners();
  }

  RectangularViewfinderLineStyle _lineStyle;
  /// The style of the viewfinder’s lines.
  ///
  /// Added in version 6.8.0
  RectangularViewfinderLineStyle get lineStyle => _lineStyle;

  /// Sets the horizontal and vertical size of the viewfinder to the provided value. When the unit is relative (unit in either x or y is [MeasureUnit.fraction]) the size is computed relative to the view size minus the scan area margins.
  ///
  /// Added in version 6.7.0
  void setSize(SizeWithUnit size) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndHeight(size);
    notifyListeners();
  }

  /// Sets the width of the viewfinder and compute height automatically based on the provided height/width aspect ratio. When the unit is relative ([MeasureUnit.fraction]), the width is computed relative to the view size minus the scan area margins.
  ///
  /// Added in version 6.7.0
  void setWidthAndAspectRatio(DoubleWithUnit width, double heightToWidthAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.widthAndAspectRatio(width, heightToWidthAspectRatio);
    notifyListeners();
  }

  /// Sets the height of the viewfinder and compute width automatically based on the provided width/height aspect ratio. When the unit is relative ([MeasureUnit.fraction]), the height is computed relative to the view size minus the scan area margins.
  ///
  /// Added in version 6.7.0
  void setHeightAndAspectRatio(DoubleWithUnit height, double widthToHeightAspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.heightAndAspectRatio(height, widthToHeightAspectRatio);
    notifyListeners();
  }

  /// Sets the viewfinder size on the short side of the scan area as **fraction** of the scan area size. The size on the long side is calculated based on the provided short side/long side **aspectRatio**.
  ///
  /// Added in version 6.8.0
  void setShorterDimensionAndAspectRatio(double fraction, double aspectRatio) {
    _sizeWithUnitAndAspect = SizeWithUnitAndAspect.shorterDimensionAndAspectRatio(fraction, aspectRatio);
    notifyListeners();
  }

  RectangularViewfinder._(this._style, this._lineStyle, this._sizeWithUnitAndAspect, this._color, this._dimming,
      this._animation, this._disabledDimming, this._disabledColor)
      : super('rectangular');

  /// Constructs a new rectangular viewfinder with [RectangularViewfinderStyle.rounded] and [RectangularViewfinderLineStyle.light].
  ///
  /// Added in version 6.7.0
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

/// Standard rectangular viewfinder animation made up of an appear animation as well as a looping animation following the appearance.
///
/// Added in version 6.8.0
class RectangularViewfinderAnimation extends Serializable {
  late bool _isLooping;

  /// Added in version 6.8.0
  RectangularViewfinderAnimation({required bool isLooping}) {
    _isLooping = isLooping;
  }

  /// Whether the looping animation should be executed.
  ///
  /// Added in version 6.8.0
  bool get isLooping => _isLooping;

  @override
  Map<String, dynamic> toMap() {
    return {'looping': isLooping};
  }
}

/// The style of the [RectangularViewfinder].
///
/// Added in version 6.8.0
enum RectangularViewfinderStyle {
  /// New style from version 6.8 onwards with rounded corners.
  ///
  /// Added in version 6.8.0
  rounded('rounded'),
  /// New style from version 6.8 onwards with square corners.
  ///
  /// Added in version 6.8.0
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

/// The style of the lines drawn as part of the [RectangularViewfinder].
///
/// Added in version 6.8.0
enum RectangularViewfinderLineStyle {
  /// Draws lines with a width of 3 dips/points.
  ///
  /// Added in version 6.8.0
  light('light'),
  /// Draws lines with a width of 5 dips/points.
  ///
  /// Added in version 6.8.0
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

/// To use this viewfinder, create a new instance and assign it to the overlay, e.g. the barcode capture overlay via the [BarcodeCaptureOverlay.viewfinder] property.
///
/// Added in version 6.7.0
class AimerViewfinder extends Viewfinder {
  Color _frameColor = Defaults.aimerViewfinderDefaults.frameColor;

  /// The color of the outer frame.
  ///
  /// Added in version 6.7.0
  Color get frameColor => _frameColor;
  /// The color of the outer frame.
  ///
  /// Added in version 6.7.0
  set frameColor(Color newValue) {
    _frameColor = newValue;
    notifyListeners();
  }

  Color _dotColor = Defaults.aimerViewfinderDefaults.dotColor;

  /// The color of the central dot. The alpha value is ignored and remains at 70%.
  ///
  /// Added in version 6.7.0
  Color get dotColor => _dotColor;
  /// The color of the central dot. The alpha value is ignored and remains at 70%.
  ///
  /// Added in version 6.7.0
  set dotColor(Color newValue) {
    _dotColor = newValue;
    notifyListeners();
  }

  /// Returns a new aimer viewfinder with default parameters.
  ///
  /// Added in version 6.7.0
  AimerViewfinder() : super('aimer');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({'frameColor': frameColor.jsonValue, 'dotColor': dotColor.jsonValue});
    return json;
  }
}

/// A horizontal laser line with a Scandit logo underneath. Toggles color depending on the capture mode enabled ([DataCaptureMode.isEnabled]) property. The laserline is centered on the data capture view’s point of interest ([DataCaptureView.pointOfInterest]).
///
/// To use this viewfinder, create a new instance and assign it to the overlay, e.g. the barcode capture overlay via the [BarcodeCaptureOverlay.viewfinder] property.
///
/// Added in version 7.4.0
class LaserlineViewfinder extends Viewfinder {
  /// The width of the laser line. The laser line is centered on the point of interest ([DataCaptureView.pointOfInterest]) of the view. When specifying the width with relative units, the width is measured relative to the view’s width minus the horizontal scan area margins.
  ///
  /// Added in version 7.4.0
  DoubleWithUnit width;
  /// The color to be used when recognition is enabled/active.
  ///
  /// Added in version 7.4.0
  Color enabledColor;
  /// The color to be used when recognition is disabled/inactive.
  ///
  /// Added in version 7.4.0
  Color disabledColor;

  LaserlineViewfinder._(this.width, this.enabledColor, this.disabledColor) : super('laserline');

  /// Constructs a new laserline viewfinder.
  ///
  /// Added in version 7.4.0
  LaserlineViewfinder()
      : this._(Defaults.laserlineViewfinderDefaults.width, Defaults.laserlineViewfinderDefaults.enabledColor,
            Defaults.laserlineViewfinderDefaults.disabledColor);

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'width': width.toMap(),
      'enabledColor': enabledColor.jsonValue,
      'disabledColor': disabledColor.jsonValue,
    });
    return json;
  }
}
