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

  static const String addOverlay = 'addOverlay';
  static const String removeOverlay = 'removeOverlay';
  static const String removeAllOverlays = 'removeAllOverlays';

  static const String eventsChannelName = 'com.scandit.datacapture.core/event_channel';
  static const String methodsChannelName = 'com.scandit.datacapture.core/method_channel';
  static const String eventFrameSourceStateChanged = 'FrameSourceListener.onStateChanged';
  static const String eventTorchStateChanged = 'TorchListener.onTorchStateChanged';
  static const String eventDataCaptureContextObservationStarted = 'DataCaptureContextListener.onObservationStarted';
  static const String eventDataCaptureContextOnStatusChanged = 'DataCaptureContextListener.onStatusChanged';
  static const String eventDataCaptureViewSizeChanged = 'DataCaptureViewListener.onSizeChanged';
}
