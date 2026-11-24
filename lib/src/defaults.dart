/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/src/source/camera_position.dart';
import 'package:scandit_flutter_datacapture_core/src/source/focus_gesture_strategy.dart';
import 'package:scandit_flutter_datacapture_core/src/source/focus_range.dart';
import 'package:scandit_flutter_datacapture_core/src/function_names.dart';
import 'package:scandit_flutter_datacapture_core/src/source/video_resolution.dart';
import 'package:scandit_flutter_datacapture_core/src/source/macro_mode.dart';

import 'common.dart';
import 'focus_gesture.dart';
import 'zoom_gesture.dart';
import 'viewfinder.dart';
import 'logo_style.dart';
import 'source/zoom_switch_orientation.dart';
import 'generated/core_generated_defaults.dart';
import 'internal/logging/logging_method_channel.dart';

// Picks the platform-split value of a generated default (e.g. focusRange,
// which differs between Android and iOS native defaults). Kept private:
// nothing else in this package needs platform-conditional static defaults.
T _platformDefault<T>({required T android, required T ios}) => Platform.isIOS ? ios : android;

@immutable
class CameraSettingsDefaults {
  final VideoResolution preferredResolution;
  final double zoomFactor;
  final FocusRange focusRange;
  final FocusGestureStrategy focusGestureStrategy;
  final double zoomGestureZoomFactor;
  final bool shouldPreferSmoothAutoFocus;
  final double torchLevel;
  final MacroMode macroMode;
  final bool adaptiveExposure;
  final Map<String, dynamic> properties;

  const CameraSettingsDefaults(this.preferredResolution, this.zoomFactor, this.focusRange, this.focusGestureStrategy,
      this.zoomGestureZoomFactor, this.properties,
      {required this.shouldPreferSmoothAutoFocus,
      this.torchLevel = 1.0,
      this.macroMode = MacroMode.auto,
      this.adaptiveExposure = false});

  factory CameraSettingsDefaults.fromJSON(Map<String, dynamic> json) {
    var resolution = VideoResolution.fromJSON(json['preferredResolution']);
    var zoomFactor = (json['zoomFactor'] as num).toDouble();
    var focusRange = FocusRangeDeserializer.focusRangeFromJSON(json['focusRange']);
    var focusGestureStrategy = FocusGestureStrategy.fromJSON(json['focusGestureStrategy']);
    var zoomGestureZoomFactor = (json['zoomGestureZoomFactor'] as num).toDouble();
    var shouldPreferSmoothAutoFocus = json['shouldPreferSmoothAutoFocus'] as bool?;
    var torchLevel = (json['torchLevel'] as num?)?.toDouble() ?? 1.0;
    var macroMode = json['macroMode'] != null ? MacroMode.fromJSON(json['macroMode']) : MacroMode.auto;
    var adaptiveExposure = json['adaptiveExposure'] as bool? ?? false;
    var properties = <String, dynamic>{};

    if (json.containsKey('properties')) {
      properties = json['properties'] as Map<String, dynamic>;
    }
    return CameraSettingsDefaults(
        resolution, zoomFactor, focusRange, focusGestureStrategy, zoomGestureZoomFactor, properties,
        shouldPreferSmoothAutoFocus: shouldPreferSmoothAutoFocus ?? false,
        torchLevel: torchLevel,
        macroMode: macroMode,
        adaptiveExposure: adaptiveExposure);
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
    var position = cameraPositionJSON == null ? null : CameraPosition.fromJSON(cameraPositionJSON);
    var availablePositions = (json['availablePositions'])
        // ignore: unnecessary_lambdas
        .map((position) => CameraPosition.fromJSON(position))
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
  final List<ZoomGesture> zoomGestures;
  final FocusGesture? focusGesture;
  final LogoStyle logoStyle;
  final bool? shouldShowZoomNotification;

  const DataCaptureViewDefaults(this.scanAreaMargins, this.pointOfInterest, this.logoAnchor, this.logoOffset,
      this.focusGesture, this.zoomGesture, this.logoStyle, this.shouldShowZoomNotification,
      {this.zoomGestures = const []});

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
    List<ZoomGesture> zoomGestures;
    if (json.containsKey('zoomGestures')) {
      zoomGestures = ZoomGestureDeserializer.fromJSONArray(json['zoomGestures'] as List<dynamic>);
    } else if (zoomGesture != null) {
      zoomGestures = [zoomGesture];
    } else {
      zoomGestures = [];
    }
    var logoStyle = LogoStyleDeserializer.fromJSON(json['logoStyle']);
    var shouldShowZoomNotification = json['shouldShowZoomNotification'] as bool?;
    return DataCaptureViewDefaults(scanAreaMargins, pointOfInterest, logoAnchor, logoOffset, focusGesture, zoomGesture,
        logoStyle, shouldShowZoomNotification,
        zoomGestures: zoomGestures);
  }
}

@immutable
class ZoomSwitchControlDefaults {
  final ZoomSwitchOrientation orientation;
  final bool isAlwaysExpanded;
  final bool isExpanded;
  final String accessibilityLabel;
  final String accessibilityHint;

  const ZoomSwitchControlDefaults({
    required this.orientation,
    required this.isAlwaysExpanded,
    required this.isExpanded,
    required this.accessibilityLabel,
    required this.accessibilityHint,
  });

  factory ZoomSwitchControlDefaults.fromJSON(Map<String, dynamic> json) {
    return ZoomSwitchControlDefaults(
      orientation: ZoomSwitchOrientation.fromJSON(json['orientation'] as String),
      isAlwaysExpanded: json['isAlwaysExpanded'] as bool,
      isExpanded: json['isExpanded'] as bool,
      accessibilityLabel: json['accessibilityLabel'] as String,
      accessibilityHint: json['accessibilityHint'] as String? ?? '',
    );
  }
}

@immutable
class MacroModeControlDefaults {
  final String? autoBase64Image;
  final String? offBase64Image;
  final String? onBase64Image;
  final String? accessibilityLabelWhenAuto;
  final String? accessibilityHintWhenAuto;
  final String? accessibilityLabelWhenOff;
  final String? accessibilityHintWhenOff;
  final String? accessibilityLabelWhenOn;
  final String? accessibilityHintWhenOn;

  const MacroModeControlDefaults({
    this.autoBase64Image,
    this.offBase64Image,
    this.onBase64Image,
    this.accessibilityLabelWhenAuto,
    this.accessibilityHintWhenAuto,
    this.accessibilityLabelWhenOff,
    this.accessibilityHintWhenOff,
    this.accessibilityLabelWhenOn,
    this.accessibilityHintWhenOn,
  });

  factory MacroModeControlDefaults.fromJSON(Map<String, dynamic>? json) {
    if (json == null) {
      return const MacroModeControlDefaults();
    }
    final icon = json['icon'] as Map<String, dynamic>?;
    return MacroModeControlDefaults(
      autoBase64Image: icon?['auto'] as String?,
      offBase64Image: icon?['off'] as String?,
      onBase64Image: icon?['on'] as String?,
      accessibilityLabelWhenAuto: json['accessibilityLabelWhenAuto'] as String?,
      accessibilityHintWhenAuto: json['accessibilityHintWhenAuto'] as String?,
      accessibilityLabelWhenOff: json['accessibilityLabelWhenOff'] as String?,
      accessibilityHintWhenOff: json['accessibilityHintWhenOff'] as String?,
      accessibilityLabelWhenOn: json['accessibilityLabelWhenOn'] as String?,
      accessibilityHintWhenOn: json['accessibilityHintWhenOn'] as String?,
    );
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

// Builds the static (platform-fixed, non-device-dependent) portion of
// CameraSettingsDefaults straight from the generated consts - no
// method-channel call involved. Kept private: only Defaults needs it, and
// exposing it would let callers bypass Defaults.cameraDefaults.
CameraSettingsDefaults _buildStaticCameraSettingsDefaults() {
  final focusRange = _platformDefault(
    android: CameraSettingsGeneratedDefaults.focusRangeAndroid,
    ios: CameraSettingsGeneratedDefaults.focusRangeIos,
  );
  return CameraSettingsDefaults(
    VideoResolution.fromJSON(CameraSettingsGeneratedDefaults.preferredResolution),
    CameraSettingsGeneratedDefaults.zoomFactor,
    FocusRangeDeserializer.focusRangeFromJSON(focusRange),
    FocusGestureStrategy.fromJSON(CameraSettingsGeneratedDefaults.focusGestureStrategy),
    CameraSettingsGeneratedDefaults.zoomGestureZoomFactor,
    // Both wrappers DO emit a 'properties' key unconditionally
    // (CameraSettingsDefaults.kt:26, .swift:40), but for a freshly constructed
    // CameraSettings its contents null-filter to an empty map
    // (CameraSettingsPropertiesDefaults.kt:73, .swift:56), so the original
    // fromJSON path produced an empty map here too. Note this holds only for
    // CameraSettings: RecommendedCameraSettings does carry properties.* values,
    // which is why those stay on the native path.
    const <String, dynamic>{},
    shouldPreferSmoothAutoFocus: CameraSettingsGeneratedDefaults.shouldPreferSmoothAutoFocus,
    torchLevel: CameraSettingsGeneratedDefaults.torchLevel,
    macroMode: MacroMode.fromJSON(CameraSettingsGeneratedDefaults.macroMode),
    adaptiveExposure: CameraSettingsGeneratedDefaults.adaptiveExposure,
  );
}

DataCaptureViewDefaults _buildStaticCaptureViewDefaults() {
  final zoomGesture = ZoomGestureDeserializer.fromJSON(DataCaptureViewGeneratedDefaults.zoomGesture);
  return DataCaptureViewDefaults(
    MarginsWithUnit.fromJSON(DataCaptureViewGeneratedDefaults.scanAreaMargins),
    PointWithUnit.fromJSON(DataCaptureViewGeneratedDefaults.pointOfInterest),
    AnchorDeserializer.fromJSON(DataCaptureViewGeneratedDefaults.logoAnchor),
    PointWithUnit.fromJSON(DataCaptureViewGeneratedDefaults.logoOffset),
    FocusGestureDeserializer.fromJSON(DataCaptureViewGeneratedDefaults.focusGesture),
    zoomGesture,
    LogoStyleDeserializer.fromJSON(DataCaptureViewGeneratedDefaults.logoStyle),
    DataCaptureViewGeneratedDefaults.shouldShowZoomNotification,
    zoomGestures: DataCaptureViewGeneratedDefaults.zoomGestures
        .map((gesture) => ZoomGestureDeserializer.fromJSON(gesture as Map<String, dynamic>))
        .whereType<ZoomGesture>()
        .toList(),
  );
}

RectangularViewfinderStyleDefaults _buildStaticRectangularViewfinderStyleDefaults({
  required RectangularViewfinderStyle style,
  required Map<String, Object?> size,
  required String color,
  required String lineStyle,
  required double dimming,
  required Map<String, Object?> animation,
  required double disabledDimming,
  required String disabledColor,
}) {
  return RectangularViewfinderStyleDefaults(
    style,
    SizeWithUnitAndAspect.fromJSON(size),
    ColorDeserializer.fromRgbaHex(color),
    dimming,
    RectangularViewfinderLineStyleDeserializer.fromJSON(lineStyle),
    RectangularViewfinderAnimation(isLooping: animation['looping'] as bool),
    disabledDimming,
    ColorDeserializer.fromRgbaHex(disabledColor),
  );
}

RectangularViewfinderDefaults _buildStaticRectangularViewfinderDefaults() {
  final styles = <RectangularViewfinderStyle, RectangularViewfinderStyleDefaults>{
    RectangularViewfinderStyle.rounded: _buildStaticRectangularViewfinderStyleDefaults(
      style: RectangularViewfinderStyle.rounded,
      size: RectangularViewfinderGeneratedDefaults.stylesRoundedSize,
      color: RectangularViewfinderGeneratedDefaults.stylesRoundedColor,
      lineStyle: RectangularViewfinderGeneratedDefaults.stylesRoundedLineStyle,
      dimming: RectangularViewfinderGeneratedDefaults.stylesRoundedDimming,
      animation: RectangularViewfinderGeneratedDefaults.stylesRoundedAnimation,
      disabledDimming: RectangularViewfinderGeneratedDefaults.stylesRoundedDisabledDimming,
      disabledColor: RectangularViewfinderGeneratedDefaults.stylesRoundedDisabledColor,
    ),
    RectangularViewfinderStyle.square: _buildStaticRectangularViewfinderStyleDefaults(
      style: RectangularViewfinderStyle.square,
      size: RectangularViewfinderGeneratedDefaults.stylesSquareSize,
      color: RectangularViewfinderGeneratedDefaults.stylesSquareColor,
      lineStyle: RectangularViewfinderGeneratedDefaults.stylesSquareLineStyle,
      dimming: RectangularViewfinderGeneratedDefaults.stylesSquareDimming,
      animation: RectangularViewfinderGeneratedDefaults.stylesSquareAnimation,
      disabledDimming: RectangularViewfinderGeneratedDefaults.stylesSquareDisabledDimming,
      disabledColor: RectangularViewfinderGeneratedDefaults.stylesSquareDisabledColor,
    ),
  };
  final defaultStyle =
      styles[RectangularViewfinderStyleDeserializer.fromJSON(RectangularViewfinderGeneratedDefaults.defaultStyle)];
  if (defaultStyle == null) {
    throw Exception("Default style not found for RectangularViewfinder");
  }
  return RectangularViewfinderDefaults(defaultStyle, styles);
}

BrushDefaults _buildStaticBrushDefaults() {
  return BrushDefaults(
    ColorDeserializer.fromRgbaHex(BrushGeneratedDefaults.fillColor),
    ColorDeserializer.fromRgbaHex(BrushGeneratedDefaults.strokeColor),
    BrushGeneratedDefaults.strokeWidth,
  );
}

AimerViewfinderDefaults _buildStaticAimerViewfinderDefaults() {
  return AimerViewfinderDefaults(
    ColorDeserializer.fromRgbaHex(AimerViewfinderGeneratedDefaults.frameColor),
    ColorDeserializer.fromRgbaHex(AimerViewfinderGeneratedDefaults.dotColor),
  );
}

LaserlineViewfinderDefaults _buildStaticLaserlineViewfinderDefaults() {
  return LaserlineViewfinderDefaults(
    DoubleWithUnit.fromJSON(LaserlineViewfinderGeneratedDefaults.width),
    ColorDeserializer.fromRgbaHex(LaserlineViewfinderGeneratedDefaults.enabledColor),
    ColorDeserializer.fromRgbaHex(LaserlineViewfinderGeneratedDefaults.disabledColor),
  );
}

ZoomSwitchControlDefaults _buildStaticZoomSwitchControlDefaults({required String accessibilityLabel}) {
  return ZoomSwitchControlDefaults(
    orientation: ZoomSwitchOrientation.fromJSON(ZoomSwitchControlGeneratedDefaults.orientation),
    isAlwaysExpanded: ZoomSwitchControlGeneratedDefaults.isAlwaysExpanded,
    isExpanded: ZoomSwitchControlGeneratedDefaults.isExpanded,
    accessibilityLabel: accessibilityLabel,
    // iOS-only field: Android's ZoomSwitchControlDefaults.kt emits no
    // accessibilityHint, so native's blob left it at '' there.
    accessibilityHint: _platformDefault(android: '', ios: ZoomSwitchControlGeneratedDefaults.accessibilityHint),
  );
}

// ignore: avoid_classes_with_only_static_members
class Defaults {
  // Statically sourced from generated/core_generated_defaults.dart - byte
  // identical to the native getDefaults() response, available immediately,
  // no method-channel round trip needed. See SDC-32174.
  static DataCaptureViewDefaults captureViewDefaults = _buildStaticCaptureViewDefaults();
  static RectangularViewfinderDefaults rectangularViewfinderDefaults = _buildStaticRectangularViewfinderDefaults();
  static BrushDefaults brushDefaults = _buildStaticBrushDefaults();
  static AimerViewfinderDefaults aimerViewfinderDefaults = _buildStaticAimerViewfinderDefaults();
  static LaserlineViewfinderDefaults laserlineViewfinderDefaults = _buildStaticLaserlineViewfinderDefaults();

  // orientation/isAlwaysExpanded/isExpanded/accessibilityHint are static;
  // accessibilityLabel is device-dependent (contains the current zoom
  // level) and is only ever set by initializeDefaults from the native
  // getDefaults() response - '' until then.
  static ZoomSwitchControlDefaults zoomSwitchControlDefaults =
      _buildStaticZoomSwitchControlDefaults(accessibilityLabel: '');

  // Camera.Settings is static and readable immediately; defaultPosition/
  // availablePositions are device-dependent and stay null/empty until
  // initializeDefaults populates them from the native getDefaults() response.
  static CameraDefaults cameraDefaults =
      CameraDefaults(_buildStaticCameraSettingsDefaults(), null, const <CameraPosition>[]);

  // Fully dynamic: only ever known from the native getDefaults() response.
  static late String sdkVersion;
  static late String deviceId;
  static MacroModeControlDefaults macroModeControlDefaults = const MacroModeControlDefaults();

  static bool _isInitialized = false;

  static void initializeDefaults(String defaultsJSON) {
    _isInitialized = false;
    Map<String, dynamic> defaults = jsonDecode(defaultsJSON);

    final cameraJSON = defaults['Camera'] as Map<String, dynamic>?;
    String? cameraPositionJSON = cameraJSON?['defaultPosition'] as String?;
    var defaultPosition = cameraPositionJSON == null ? null : CameraPosition.fromJSON(cameraPositionJSON);
    var availablePositions = ((cameraJSON?['availablePositions'] as List<dynamic>?) ?? const <dynamic>[])
        // ignore: unnecessary_lambdas
        .map((position) => CameraPosition.fromJSON(position))
        .toList()
        .cast<CameraPosition>();
    cameraDefaults = CameraDefaults(_buildStaticCameraSettingsDefaults(), defaultPosition, availablePositions);

    sdkVersion = defaults['Version'] as String;
    deviceId = defaults['deviceID'] as String;

    final zoomSwitchControlJSON = defaults['ZoomSwitchControl'] as Map<String, dynamic>?;
    zoomSwitchControlDefaults = _buildStaticZoomSwitchControlDefaults(
      accessibilityLabel:
          zoomSwitchControlJSON?['accessibilityLabel'] as String? ?? zoomSwitchControlDefaults.accessibilityLabel,
    );

    macroModeControlDefaults = MacroModeControlDefaults.fromJSON(defaults['MacroModeControl'] as Map<String, dynamic>?);
    _isInitialized = true;
  }

  static Future<dynamic> initializeDefaultsAsync() async {
    if (_isInitialized) return;
    final channel = const LoggingMethodChannel(FunctionNames.methodsChannelName);
    // Narrow endpoint: only the residual keys read below (Version, deviceID, the
    // device-probed camera positions, the localized ZoomSwitchControl label and
    // the MacroModeControl block). It is the only defaults endpoint - the
    // full-blob getDefaults was removed in SDC-32178.
    String result = await channel.invokeMethod('getDynamicDefaults');
    initializeDefaults(result);
  }
}
