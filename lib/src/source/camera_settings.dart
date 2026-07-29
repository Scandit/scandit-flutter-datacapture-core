/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/src/common.dart';
import 'package:scandit_flutter_datacapture_core/src/source/focus_gesture_strategy.dart';
import 'package:scandit_flutter_datacapture_core/src/source/focus_range.dart';
import 'package:scandit_flutter_datacapture_core/src/source/video_resolution.dart';

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

  VideoResolution preferredResolution;
  double zoomFactor;
  FocusRange focusRange;
  FocusGestureStrategy focusGestureStrategy;
  double zoomGestureZoomFactor;
  bool shouldPreferSmoothAutoFocus;

  void setProperty<T>(String name, T value) {
    if (_focusHiddenProperties.contains(name)) {
      _cameraFocusHiddenProperties[name] = value;
      return;
    }
    _cameraSettingsProperties[name] = value;
  }

  T getProperty<T>(String name) {
    if (_focusHiddenProperties.contains(name)) {
      return _cameraFocusHiddenProperties[name] as T;
    }
    return _cameraSettingsProperties[name] as T;
  }

  CameraSettings(
      this.preferredResolution, this.zoomFactor, this.focusRange, this.focusGestureStrategy, this.zoomGestureZoomFactor,
      {required this.shouldPreferSmoothAutoFocus, Map<String, dynamic> properties = const <String, dynamic>{}}) {
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
      'zoomGestureZoomFactor': zoomGestureZoomFactor
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
