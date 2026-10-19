/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

class FunctionNames {
  static const String setDefaultsMethodName = 'setDefaults';
  static const String updateContextFromJSONMethodName = 'updateContextFromJSON';
  static const String getCameraStateMethodName = 'getCameraState';
  static const String createContextFromJSONMethodName = 'createContextFromJSON';
  static const String emitFeedbackMethodName = 'emitFeedback';
  static const String viewPointForFramePoint = 'viewPointForFramePoint';
  static const String viewQuadrilateralForFrameQuadrilateral = 'viewQuadrilateralForFrameQuadrilateral';
  static const String isTorchAvailableMethodName = 'isTorchAvailable';
  static const String switchCameraToDesiredState = 'switchCameraToDesiredState';
  static const String updateDataCaptureView = 'updateDataCaptureView';
  static const String addModeToContext = 'addModeToContext';
  static const String removeModeFromContext = 'removeModeFromContext';
  static const String removeAllModesFromContext = 'removeAllModesFromContext';
  static const String getOpenSourceSoftwareLicenseInfo = 'getOpenSourceSoftwareLicenseInfo';

  static const String methodsChannelName = 'com.scandit.datacapture.core/method_channel';
  static const String eventFrameSourceStateChanged = 'FrameSourceListener.onStateChanged';
  static const String eventTorchStateChanged = 'TorchListener.onTorchStateChanged';
  static const String eventMacroModeChanged = 'MacroModeListener.onMacroModeChanged';
  static const String eventDataCaptureContextObservationStarted = 'DataCaptureContextListener.onObservationStarted';
  static const String eventDataCaptureContextOnStatusChanged = 'DataCaptureContextListener.onStatusChanged';
  static const String eventDataCaptureViewSizeChanged = 'DataCaptureViewListener.onSizeChanged';
  static const String eventFocusGesture = 'FocusGestureListener.onFocusGesture';
  static const String eventZoomInGesture = 'ZoomGestureListener.onZoomInGesture';
  static const String eventZoomOutGesture = 'ZoomGestureListener.onZoomOutGesture';
  static const String eventZoomLevelChanged = 'ZoomListener.onZoomLevelChanged';
}
