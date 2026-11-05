/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/src/common.dart';
import 'package:scandit_flutter_datacapture_core/src/defaults.dart';
import 'package:scandit_flutter_datacapture_core/src/source/focus_gesture_strategy.dart';
import 'package:scandit_flutter_datacapture_core/src/source/focus_range.dart';
import 'package:scandit_flutter_datacapture_core/src/source/video_resolution.dart';
import 'package:scandit_flutter_datacapture_core/src/source/macro_mode.dart';

/// Holds camera-specific settings such as preferred resolution, maximum frame rate etc. The defaults are chosen such that they work for a wide variety of use cases. You may apply custom settings to further optimize scan performance for your particular use case. There is typically no need to customize the camera settings beyond changing the preferred resolution ([CameraSettings.preferredResolution]).
///
/// For best performance use the camera settings returned by the capture mode you are using, e.g. [BarcodeCapture.createRecommendedCameraSettings], or [BarcodeBatch.createRecommendedCameraSettings] etc.
///
/// Holds camera related settings such as preview resolution and maximum frame rate to use.
///
/// Added in version 6.7.0
class CameraSettings implements Serializable {
  final Map<String, dynamic> _cameraSettingsProperties = <String, dynamic>{};

  final Map<String, dynamic> _cameraFocusHiddenProperties = <String, dynamic>{};
  final _focusHiddenProperties = [
    'range',
    'manualLensPosition',
    'shouldPreferSmoothAutoFocus',
    'focusStrategy',
    'focusGestureStrategy'
  ];

  /// The preferred resolution to use for the camera. The camera will use the resolution that is closests to the resolution preference. For example, if only lower resolutions than the preferred resolution are available, the highest available resolution will be used.
  ///
  /// The resolution chosen by the camera only takes the [CameraSettings.preferredResolution] into account, it does not consider the resolution limit of your license key. When the device selects a resolution that is larger than what you have licensed, the data capture context will report a license status error.
  ///
  /// The default value is [VideoResolution.fullHd].
  ///
  /// Added in version 6.7.0
  VideoResolution preferredResolution;
  /// The zoom factor to use for the camera. This value is a multiplier, a value of 1.0 means no zoom, while a value of 2.0 doubles the size of the image, but halves the field of view.
  ///
  /// Values less than 1.0 are treated as 1.0. Values greater than the maximum available zoom factor are clamped to the maximum accepted value.
  ///
  /// The default zoom factor is 1.0.
  ///
  /// Added in version 6.7.0
  double zoomFactor;
  /// The focus range to primarily use, if supported by the device.
  ///
  /// On Android changing this property has no effect.
  ///
  /// Added in version 6.7.0
  FocusRange focusRange;
  /// The focus gesture strategy to use.
  ///
  /// Added in version 6.7.0
  FocusGestureStrategy focusGestureStrategy;
  /// The zoom factor to move to when the zoom in gesture was performed. This value is a multiplier, a value of 1.0 means no zoom, while a value of 2.0 doubles the size of the image, but halves the field of view. See also [CameraSettings.zoomFactor].
  ///
  /// The default zoom factor for the zoom in gesture is 2.0.
  ///
  /// Added in version 6.7.0
  double zoomGestureZoomFactor;
  /// Whether to prefer smooth auto-focus. The default settings have this turned off. Enable it to switch to a smoother (but potentially less reliable) auto-focus strategy. For some devices, this property has no effect.
  ///
  /// Added in version 6.8.0
  bool shouldPreferSmoothAutoFocus;
  /// The torch intensity level. This value must be a number between 0.0 and 1.0. If a number outside the range is provided, either 0.0 or 1.0 will be used instead. Setting the torch level to 0.0 is equivalent to having the torch off.
  ///
  /// On Android this property has no effect.
  ///
  /// Added in version 8.3.0
  double torchLevel;
  /// The macro mode to use, if supported by the device.
  ///
  /// The default value is [MacroMode.auto].
  ///
  /// On Android this property has no effect.
  ///
  /// Added in version 8.3.0
  MacroMode macroMode;
  /// Enables adaptive exposure optimization for low-light conditions. When enabled, the camera can trade frame rate for brighter images by allowing longer exposure times. In low-light environments, the frame rate may drop from approximately 30fps to 10fps, while the maximum exposure duration increases from ~33ms to up to 100ms. In well-lit conditions, this setting has no impact on frame rate or exposure.
  ///
  /// This feature is particularly useful for scanning in challenging lighting conditions where image brightness is more critical than maintaining the highest frame rate.
  ///
  /// The default value is *false*.
  ///
  /// On Android this property has no effect.
  ///
  /// Added in version 8.3.0
  bool adaptiveExposure;
  /// The set of zoom levels available for zoom gestures and controls. Each value corresponds to a zoom factor that will be applied to the camera when zooming in our out. The camera automatically filters this list based on the camera hardware capabilities, so zoom levels unsupported by the device are omitted.
  ///
  /// The default value is `[1, 2]`.
  ///
  /// Added in version 8.4.0
  List<double> zoomLevels = [1.0, 2.0];

  /// Sets camera property to the provided value. Use this method to set properties that are not yet part of a stable API. Properties set through this method may or may not be used or change in a future release.
  ///
  /// Added in version 6.7.0
  void setProperty<T>(String name, T value) {
    if (_focusHiddenProperties.contains(name)) {
      _cameraFocusHiddenProperties[name] = value;
      return;
    }
    _cameraSettingsProperties[name] = value;
  }

  /// Retrieves the value of a previously set property. In case the property does not exist, an [ArgumentException](https://learn.microsoft.com/en-us/dotnet/api/system.argumentexception) is thrown.
  ///
  /// Added in version 6.7.0
  T getProperty<T>(String name) {
    if (_focusHiddenProperties.contains(name)) {
      return _cameraFocusHiddenProperties[name] as T;
    }
    return _cameraSettingsProperties[name] as T;
  }

  CameraSettings(
      this.preferredResolution, this.zoomFactor, this.focusRange, this.focusGestureStrategy, this.zoomGestureZoomFactor,
      {required this.shouldPreferSmoothAutoFocus,
      double? torchLevel,
      MacroMode? macroMode,
      bool? adaptiveExposure,
      Map<String, dynamic> properties = const <String, dynamic>{}})
      : torchLevel = torchLevel ?? Defaults.cameraDefaults.settings.torchLevel,
        macroMode = macroMode ?? Defaults.cameraDefaults.settings.macroMode,
        adaptiveExposure = adaptiveExposure ?? Defaults.cameraDefaults.settings.adaptiveExposure {
    for (var hiddenProperty in properties.entries) {
      setProperty(hiddenProperty.key, hiddenProperty.value);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> json;
    json = {
      'preferredResolution': preferredResolution.toString(),
      'zoomFactor': zoomFactor,
      'focusRange': focusRange.toString(),
      'focus': {
        'range': focusRange.toString(),
        'focusGestureStrategy': focusGestureStrategy.toString(),
        'shouldPreferSmoothAutoFocus': shouldPreferSmoothAutoFocus
      },
      'zoomGestureZoomFactor': zoomGestureZoomFactor,
      'torchLevel': torchLevel,
      'macroMode': macroMode.toString(),
      'adaptiveExposure': adaptiveExposure,
      'zoomLevels': zoomLevels,
    };
    _cameraFocusHiddenProperties.forEach((key, value) {
      json['focus'][key] = value;
    });
    if (_cameraSettingsProperties.isNotEmpty) {
      json.addAll(_cameraSettingsProperties);
    }
    return json;
  }
}
