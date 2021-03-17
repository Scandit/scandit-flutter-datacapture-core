/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:ui';

import 'camera.dart';
import 'common.dart';
import 'focus_gesture.dart';
import 'zoom_gesture.dart';

import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

@immutable
class CameraSettingsDefaults {
  final VideoResolution preferredResolution;
  final double zoomFactor;
  final FocusRange focusRange;
  final FocusGestureStrategy focusGestureStrategy;
  final double zoomGestureZoomFactor;

  CameraSettingsDefaults(this.preferredResolution, this.zoomFactor, this.focusRange, this.focusGestureStrategy,
      this.zoomGestureZoomFactor);

  factory CameraSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var resolution = VideoResolutionDeserializer.videoResolutionFromJSON(json['preferredResolution']);
    var zoomFactor = (json['zoomFactor'] as num).toDouble();
    var focusRange = FocusRangeDeserializer.focusRangeFromJSON(json['focusRange']);
    var focusGestureStrategy =
        FocusGestureStrategyDeserializer.focusGestureStrategyFromJSON(json['focusGestureStrategy']);
    var zoomGestureZoomFactor = (json['zoomGestureZoomFactor'] as num).toDouble();
    return CameraSettingsDefaults(resolution, zoomFactor, focusRange, focusGestureStrategy, zoomGestureZoomFactor);
  }
}

@immutable
class CameraDefaults {
  final CameraSettingsDefaults settings;
  final CameraPosition defaultPosition;
  final List<CameraPosition> availablePositions;

  CameraDefaults(this.settings, this.defaultPosition, this.availablePositions);

  factory CameraDefaults.fromJSON(Map<String, dynamic> json) {
    var cameraSettings = CameraSettingsDefaults.fromJSON(json['Settings']);
    var position = CameraPositionDeserializer.cameraPositionFromJSON(json['defaultPosition']);
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
  final ZoomGesture zoomGesture;
  final FocusGesture focusGesture;

  DataCaptureViewDefaults(this.scanAreaMargins, this.pointOfInterest, this.logoAnchor, this.logoOffset,
      this.focusGesture, this.zoomGesture);

  factory DataCaptureViewDefaults.fromJSON(Map<String, dynamic> json) {
    var scanAreaMargins = MarginsWithUnit.fromJSON(jsonDecode(json['scanAreaMargins']));
    var pointOfInterest = PointWithUnit.fromJSON(jsonDecode(json['pointOfInterest']));
    var logoAnchor = AnchorDeserializer.fromJSON(json['logoAnchor']);
    var logoOffset = PointWithUnit.fromJSON(jsonDecode(json['logoOffset']));
    FocusGesture focusGesture;
    if (json.containsKey('focusGesture')) {
      focusGesture = FocusGestureDeserializer.fromJSON(jsonDecode(json['focusGesture']));
    }
    ZoomGesture zoomGesture;
    if (json.containsKey('zoomGesture')) {
      zoomGesture = ZoomGestureDeserializer.fromJSON(jsonDecode(json['zoomGesture']));
    }
    return DataCaptureViewDefaults(scanAreaMargins, pointOfInterest, logoAnchor, logoOffset, focusGesture, zoomGesture);
  }
}

@immutable
class BrushDefaults {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;

  BrushDefaults(this.fillColor, this.strokeColor, this.strokeWidth);

  factory BrushDefaults.fromJSON(Map<String, dynamic> json) {
    var fillColor = ColorDeserializer.fromRgbaHex(json['fillColor'] as String);
    var strokeColor = ColorDeserializer.fromRgbaHex(json['strokeColor'] as String);
    var strokeWidth = (json['strokeWidth'] as num).toDouble();
    return BrushDefaults(fillColor, strokeColor, strokeWidth);
  }
}

@immutable
class LaserlineViewfinderDefaults {
  final DoubleWithUnit width;
  final Color enabledColor;
  final Color disabledColor;

  LaserlineViewfinderDefaults(this.width, this.enabledColor, this.disabledColor);

  factory LaserlineViewfinderDefaults.fromJSON(Map<String, dynamic> json) {
    var width = DoubleWithUnit.fromJSON(jsonDecode(json['width']) as Map<String, dynamic>);
    var enabledColor = ColorDeserializer.fromRgbaHex(json['enabledColor'] as String);
    var disabledColor = ColorDeserializer.fromRgbaHex(json['disabledColor'] as String);
    return LaserlineViewfinderDefaults(width, enabledColor, disabledColor);
  }
}

@immutable
class RectangularViewfinderDefaults {
  final SizeWithUnitAndAspect size;
  final Color color;

  RectangularViewfinderDefaults(this.size, this.color);

  factory RectangularViewfinderDefaults.fromJSON(Map<String, dynamic> json) {
    var size = SizeWithUnitAndAspect.fromJSON(jsonDecode(json['size']) as Map<String, dynamic>);
    var color = ColorDeserializer.fromRgbaHex(json['color'] as String);
    return RectangularViewfinderDefaults(size, color);
  }
}

@immutable
class AimerViewfinderDefaults {
  final Color frameColor;
  final Color dotColor;

  AimerViewfinderDefaults(this.frameColor, this.dotColor);

  factory AimerViewfinderDefaults.fromJSON(Map<String, dynamic> json) {
    var frameColor = ColorDeserializer.fromRgbaHex(json['frameColor'] as String);
    var dotColor = ColorDeserializer.fromRgbaHex(json['dotColor'] as String);
    return AimerViewfinderDefaults(frameColor, dotColor);
  }
}

// ignore: avoid_classes_with_only_static_members
class Defaults {
  static MethodChannel channel = MethodChannel('com.scandit.datacapture.core.method/datacapture_defaults');
  static CameraDefaults cameraDefaults;
  static DataCaptureViewDefaults captureViewDefaults;
  static LaserlineViewfinderDefaults laserlineViewfinderDefaults;
  static RectangularViewfinderDefaults rectangularViewfinderDefaults;
  static BrushDefaults brushDefaults;
  static String sdkVersion;
  static String deviceId;
  static AimerViewfinderDefaults aimerViewfinderDefaults;

  static bool _isInitialized = false;

  static Future<dynamic> initializeDefaults() async {
    if (_isInitialized) return;

    var result = await channel.invokeMethod('getDefaults');
    Map<String, dynamic> defaults = jsonDecode(result as String);
    cameraDefaults = CameraDefaults.fromJSON(defaults['Camera']);
    captureViewDefaults = DataCaptureViewDefaults.fromJSON(defaults['DataCaptureView']);
    laserlineViewfinderDefaults = LaserlineViewfinderDefaults.fromJSON(defaults['LaserlineViewfinder']);
    rectangularViewfinderDefaults = RectangularViewfinderDefaults.fromJSON(defaults['RectangularViewfinder']);
    brushDefaults = BrushDefaults.fromJSON(defaults['Brush']);
    sdkVersion = defaults['Version'] as String;
    deviceId = defaults['DeviceID'] as String;
    aimerViewfinderDefaults = AimerViewfinderDefaults.fromJSON(defaults['AimerViewfinder']);

    _isInitialized = true;
  }
}
