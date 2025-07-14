/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';

import 'camera.dart';
import 'common.dart';
import 'focus_gesture.dart';
import 'zoom_gesture.dart';
import 'viewfinder.dart';
import 'logo_style.dart';

import 'package:flutter/services.dart';

@immutable
class CameraSettingsDefaults {
  final VideoResolution preferredResolution;
  final double zoomFactor;
  final FocusRange focusRange;
  final FocusGestureStrategy focusGestureStrategy;
  final double zoomGestureZoomFactor;
  final bool shouldPreferSmoothAutoFocus;
  final Map<String, dynamic> properties;

  const CameraSettingsDefaults(this.preferredResolution, this.zoomFactor, this.focusRange, this.focusGestureStrategy,
      this.zoomGestureZoomFactor, this.properties,
      {required this.shouldPreferSmoothAutoFocus});

  factory CameraSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var resolution = VideoResolutionDeserializer.videoResolutionFromJSON(json['preferredResolution']);
    var zoomFactor = (json['zoomFactor'] as num).toDouble();
    var focusRange = FocusRangeDeserializer.focusRangeFromJSON(json['focusRange']);
    var focusGestureStrategy =
        FocusGestureStrategyDeserializer.focusGestureStrategyFromJSON(json['focusGestureStrategy']);
    var zoomGestureZoomFactor = (json['zoomGestureZoomFactor'] as num).toDouble();
    var shouldPreferSmoothAutoFocus = json['shouldPreferSmoothAutoFocus'] as bool?;
    var properties = <String, dynamic>{};

    if (json.containsKey('properties')) {
      properties = json['properties'] as Map<String, dynamic>;
    }
    return CameraSettingsDefaults(
        resolution, zoomFactor, focusRange, focusGestureStrategy, zoomGestureZoomFactor, properties,
        shouldPreferSmoothAutoFocus: shouldPreferSmoothAutoFocus ?? false);
  }
}

@immutable
class CameraDefaults {
  final CameraSettingsDefaults settings;
  final CameraPosition? defaultPosition;
  final List<CameraPosition> availablePositions;

  const CameraDefaults(this.settings, this.defaultPosition, this.availablePositions);

  factory CameraDefaults.fromJSON(Map<String, dynamic> json) {
    var cameraSettings = CameraSettingsDefaults.fromJSON(json['Settings']);
    String? cameraPositionJSON = json['defaultPosition'];
    var position =
        cameraPositionJSON == null ? null : CameraPositionDeserializer.cameraPositionFromJSON(cameraPositionJSON);
    var availablePositions = (json['availablePositions'])
        // ignore: unnecessary_lambdas
        .map((position) => CameraPositionDeserializer.cameraPositionFromJSON(position))
        .toList()
        .cast<CameraPosition>();
    return CameraDefaults(cameraSettings, position, availablePositions);
  }
}

@immutable
class DataCaptureViewDefaults {
  final MarginsWithUnit scanAreaMargins;
  final PointWithUnit pointOfInterest;
  final Anchor logoAnchor;
  final PointWithUnit logoOffset;
  final ZoomGesture? zoomGesture;
  final FocusGesture? focusGesture;
  final LogoStyle logoStyle;

  const DataCaptureViewDefaults(this.scanAreaMargins, this.pointOfInterest, this.logoAnchor, this.logoOffset,
      this.focusGesture, this.zoomGesture, this.logoStyle);

  factory DataCaptureViewDefaults.fromJSON(Map<String, dynamic> json) {
    var scanAreaMargins = MarginsWithUnit.fromJSON(jsonDecode(json['scanAreaMargins']));
    var pointOfInterest = PointWithUnit.fromJSON(jsonDecode(json['pointOfInterest']));
    var logoAnchor = AnchorDeserializer.fromJSON(json['logoAnchor']);
    var logoOffset = PointWithUnit.fromJSON(jsonDecode(json['logoOffset']));
    FocusGesture? focusGesture;
    if (json.containsKey('focusGesture')) {
      focusGesture = FocusGestureDeserializer.fromJSON(jsonDecode(json['focusGesture']));
    }
    ZoomGesture? zoomGesture;
    if (json.containsKey('zoomGesture')) {
      zoomGesture = ZoomGestureDeserializer.fromJSON(jsonDecode(json['zoomGesture']));
    }
    var logoStyle = LogoStyleDeserializer.fromJSON(json['logoStyle']);
    return DataCaptureViewDefaults(
        scanAreaMargins, pointOfInterest, logoAnchor, logoOffset, focusGesture, zoomGesture, logoStyle);
  }
}

@immutable
class BrushDefaults {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const BrushDefaults(this.fillColor, this.strokeColor, this.strokeWidth);

  factory BrushDefaults.fromJSON(Map<String, dynamic> json) {
    var fillColor = ColorDeserializer.fromRgbaHex(json['fillColor'] as String);
    var strokeColor = ColorDeserializer.fromRgbaHex(json['strokeColor'] as String);
    var strokeWidth = (json['strokeWidth'] as num).toDouble();
    return BrushDefaults(fillColor, strokeColor, strokeWidth);
  }

  Brush toBrush() => Brush(fillColor, strokeColor, strokeWidth);
}

// This class is used to deserialize the brush json serialized on the native sdk
@immutable
class NativeBrushDefaults {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  const NativeBrushDefaults(this.fillColor, this.strokeColor, this.strokeWidth);

  factory NativeBrushDefaults.fromJSON(Map<String, dynamic> json) {
    var fillColor = ColorDeserializer.fromRgbaHex(json['fill']['color'] as String);
    var strokeColor = ColorDeserializer.fromRgbaHex(json['stroke']['color'] as String);
    var strokeWidth = (json['stroke']['width'] as num).toDouble();
    return NativeBrushDefaults(fillColor, strokeColor, strokeWidth);
  }

  Brush toBrush() => Brush(fillColor, strokeColor, strokeWidth);
}

@immutable
class RectangularViewfinderDefaults {
  final RectangularViewfinderStyleDefaults defaultStyle;
  final Map<RectangularViewfinderStyle, RectangularViewfinderStyleDefaults> styles;

  const RectangularViewfinderDefaults(this.defaultStyle, this.styles);

  factory RectangularViewfinderDefaults.fromJSON(Map<String, dynamic> json) {
    var styles = (json['styles'] as Map<String, dynamic>).map((key, value) => MapEntry(
        RectangularViewfinderStyleDeserializer.fromJSON(key), RectangularViewfinderStyleDefaults.fromJSON(value)));
    var defaultStyle = styles[RectangularViewfinderStyleDeserializer.fromJSON(json['defaultStyle'] as String)];

    if (defaultStyle == null) {
      throw Exception("Default style not found for RectangularViewfinder");
    }

    return RectangularViewfinderDefaults(defaultStyle, styles);
  }
}

@immutable
class RectangularViewfinderStyleDefaults {
  final SizeWithUnitAndAspect size;
  final Color color;
  final Color disabledColor;
  final RectangularViewfinderStyle style;
  final double dimming;
  final RectangularViewfinderLineStyle lineStyle;
  final RectangularViewfinderAnimation? animation;
  final double disabledDimming;

  const RectangularViewfinderStyleDefaults(this.style, this.size, this.color, this.dimming, this.lineStyle,
      this.animation, this.disabledDimming, this.disabledColor);

  factory RectangularViewfinderStyleDefaults.fromJSON(Map<String, dynamic> json) {
    var size = SizeWithUnitAndAspect.fromJSON(jsonDecode(json['size']) as Map<String, dynamic>);
    var color = ColorDeserializer.fromRgbaHex(json['color'] as String);
    var disabledColor = ColorDeserializer.fromRgbaHex(json['disabledColor'] as String);
    var style = RectangularViewfinderStyleDeserializer.fromJSON(json['style'] as String);
    var dimming = (json['dimming'] as num).toDouble();
    var lineStyle = RectangularViewfinderLineStyleDeserializer.fromJSON(json['lineStyle'] as String);
    RectangularViewfinderAnimation? animation;
    if (json.containsKey('animation') && json['animation'] != null) {
      var animationJson = jsonDecode(json['animation']);
      animation = RectangularViewfinderAnimation(isLooping: animationJson['looping'] as bool);
    }
    var disabledDimming = (json['disabledDimming'] as num).toDouble();

    return RectangularViewfinderStyleDefaults(
        style, size, color, dimming, lineStyle, animation, disabledDimming, disabledColor);
  }
}

@immutable
class AimerViewfinderDefaults {
  final Color frameColor;
  final Color dotColor;

  const AimerViewfinderDefaults(this.frameColor, this.dotColor);

  factory AimerViewfinderDefaults.fromJSON(Map<String, dynamic> json) {
    var frameColor = ColorDeserializer.fromRgbaHex(json['frameColor'] as String);
    var dotColor = ColorDeserializer.fromRgbaHex(json['dotColor'] as String);
    return AimerViewfinderDefaults(frameColor, dotColor);
  }
}

@immutable
class LaserlineViewfinderDefaults {
  final DoubleWithUnit width;
  final Color enabledColor;
  final Color disabledColor;

  const LaserlineViewfinderDefaults(this.width, this.enabledColor, this.disabledColor);

  factory LaserlineViewfinderDefaults.fromJSON(Map<String, dynamic> json) {
    var width = DoubleWithUnit.fromJSON(jsonDecode(json['width']) as Map<String, dynamic>);
    var enabledColor = ColorDeserializer.fromRgbaHex(json['enabledColor'] as String);
    var disabledColor = ColorDeserializer.fromRgbaHex(json['disabledColor'] as String);
    return LaserlineViewfinderDefaults(width, enabledColor, disabledColor);
  }
}

// ignore: avoid_classes_with_only_static_members
class Defaults {
  static MethodChannel channel = const MethodChannel(FunctionNames.methodsChannelName);
  static late CameraDefaults cameraDefaults;
  static late DataCaptureViewDefaults captureViewDefaults;
  static late RectangularViewfinderDefaults rectangularViewfinderDefaults;
  static late BrushDefaults brushDefaults;
  static late String sdkVersion;
  static late String deviceId;
  static late AimerViewfinderDefaults aimerViewfinderDefaults;
  static late LaserlineViewfinderDefaults laserlineViewfinderDefaults;
  static bool _isInitialized = false;

  static void initializeDefaults(String defaultsJSON) {
    _isInitialized = false;
    Map<String, dynamic> defaults = jsonDecode(defaultsJSON);
    cameraDefaults = CameraDefaults.fromJSON(defaults['Camera']);
    captureViewDefaults = DataCaptureViewDefaults.fromJSON(defaults['DataCaptureView']);
    rectangularViewfinderDefaults = RectangularViewfinderDefaults.fromJSON(defaults['RectangularViewfinder']);
    brushDefaults = BrushDefaults.fromJSON(defaults['Brush']);
    sdkVersion = defaults['Version'] as String;
    deviceId = defaults['deviceID'] as String;
    aimerViewfinderDefaults = AimerViewfinderDefaults.fromJSON(defaults['AimerViewfinder']);
    laserlineViewfinderDefaults = LaserlineViewfinderDefaults.fromJSON(defaults['LaserlineViewfinder']);
    _isInitialized = true;
  }

  static Future<dynamic> initializeDefaultsAsync() async {
    if (_isInitialized) return;

    String result = await channel.invokeMethod('getDefaults');
    initializeDefaults(result);
  }
}
