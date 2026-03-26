/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/core.json

import 'dart:convert';
import 'package:flutter/services.dart';

/// Generated Core method handler for Flutter.
/// Routes all Core method calls through a single executeCore entry point.
class CoreMethodHandler {
  final MethodChannel _methodChannel;

  CoreMethodHandler(this._methodChannel);

  /// Single entry point for all Core operations.
  /// Routes to appropriate native command based on moduleName and methodName.
  Future<dynamic> executeCore(String moduleName, String methodName, Map<String, dynamic> params) async {
    final arguments = {
      'moduleName': moduleName,
      'methodName': methodName,
      ...params,
    };
    return await _methodChannel.invokeMethod('executeCore', arguments);
  }

  /// Gets the camera state for a given position
  Future<Map<String, dynamic>> getCameraState({required String cameraPosition}) async {
    final params = {
      'cameraPosition': cameraPosition,
    };
    final result = await executeCore('CoreModule', 'getCameraState', params);
    return jsonDecode(result) as Map<String, dynamic>;
  }

  /// Switches the camera to the desired state
  Future<void> switchCameraToDesiredState({required String stateJson}) async {
    final params = {
      'stateJson': stateJson,
    };
    return await executeCore('CoreModule', 'switchCameraToDesiredState', params);
  }

  /// Checks if torch is available for the given camera position
  Future<bool> isTorchAvailable({required String cameraPosition}) async {
    final params = {
      'cameraPosition': cameraPosition,
    };
    final result = await executeCore('CoreModule', 'isTorchAvailable', params);
    return result == 'true';
  }

  /// Checks if macro mode is available for the current device
  Future<bool> isMacroModeAvailable() async {
    final result = await executeCore('CoreModule', 'isMacroModeAvailable', {});
    return result == 'true';
  }

  /// Registers a persistent listener for frame source state change events
  Future<void> registerFrameSourceListener() async {
    return await executeCore('CoreModule', 'registerFrameSourceListener', {});
  }

  /// Unregisters the frame source event listener
  Future<void> unregisterFrameSourceListener() async {
    return await executeCore('CoreModule', 'unregisterFrameSourceListener', {});
  }

  /// Registers a persistent listener for torch state change events
  Future<void> registerTorchStateListener() async {
    return await executeCore('CoreModule', 'registerTorchStateListener', {});
  }

  /// Unregisters the torch state event listener
  Future<void> unregisterTorchStateListener() async {
    return await executeCore('CoreModule', 'unregisterTorchStateListener', {});
  }

  /// Registers a persistent listener for macro mode change events
  Future<void> registerMacroModeListener() async {
    return await executeCore('CoreModule', 'registerMacroModeListener', {});
  }

  /// Unregisters the macro mode event listener
  Future<void> unregisterMacroModeListener() async {
    return await executeCore('CoreModule', 'unregisterMacroModeListener', {});
  }

  /// Gets the last frame data by frame ID as JSON
  Future<String> getLastFrameAsJson({required String frameId}) async {
    final params = {
      'frameId': frameId,
    };
    final result = await executeCore('CoreModule', 'getLastFrameAsJson', params);
    return result;
  }

  /// Gets the last frame data by frame ID as JSON, or null if not found
  Future<String?> getLastFrameOrNullAsJson({required String frameId}) async {
    final params = {
      'frameId': frameId,
    };
    final result = await executeCore('CoreModule', 'getLastFrameOrNullAsJson', params);
    if (result == null) return null;
    return result;
  }

  /// Gets the last frame data by frame ID as a map, or null if not found
  Future<Map<String, dynamic>?> getLastFrameOrNullAsMap({required String frameId}) async {
    final params = {
      'frameId': frameId,
    };
    final result = await executeCore('CoreModule', 'getLastFrameOrNullAsMap', params);
    if (result == null) return null;
    return (result as Map).cast<String, dynamic>();
  }

  /// Creates a DataCaptureContext from JSON
  Future<void> createContextFromJson({required String contextJson}) async {
    final params = {
      'contextJson': contextJson,
    };
    return await executeCore('CoreModule', 'createContextFromJson', params);
  }

  /// Updates a DataCaptureContext from JSON
  Future<void> updateContextFromJson({required String contextJson}) async {
    final params = {
      'contextJson': contextJson,
    };
    return await executeCore('CoreModule', 'updateContextFromJson', params);
  }

  /// Subscribes to context events with persistent listener
  Future<void> subscribeContextListener() async {
    return await executeCore('CoreModule', 'subscribeContextListener', {});
  }

  /// Unsubscribes from context events
  Future<void> unsubscribeContextListener() async {
    return await executeCore('CoreModule', 'unsubscribeContextListener', {});
  }

  /// Adds a mode to the DataCaptureContext
  Future<void> addModeToContext({required String modeJson}) async {
    final params = {
      'modeJson': modeJson,
    };
    return await executeCore('CoreModule', 'addModeToContext', params);
  }

  /// Removes a mode from the DataCaptureContext
  Future<void> removeModeFromContext({required String modeJson}) async {
    final params = {
      'modeJson': modeJson,
    };
    return await executeCore('CoreModule', 'removeModeFromContext', params);
  }

  /// Removes all modes from the DataCaptureContext
  Future<void> removeAllModes() async {
    return await executeCore('CoreModule', 'removeAllModes', {});
  }

  /// Gets open source software license information
  Future<String> getOpenSourceSoftwareLicenseInfo() async {
    final result = await executeCore('CoreModule', 'getOpenSourceSoftwareLicenseInfo', {});
    return result;
  }

  /// Disposes the DataCaptureContext and releases resources
  Future<void> disposeContext() async {
    return await executeCore('CoreModule', 'disposeContext', {});
  }

  /// Converts a point from frame coordinates to view coordinates
  Future<String> viewPointForFramePoint({required int viewId, required String pointJson}) async {
    final params = {
      'viewId': viewId,
      'pointJson': pointJson,
    };
    final result = await executeCore('CoreModule', 'viewPointForFramePoint', params);
    return result;
  }

  /// Converts a quadrilateral from frame coordinates to view coordinates
  Future<String> viewQuadrilateralForFrameQuadrilateral(
      {required int viewId, required String quadrilateralJson}) async {
    final params = {
      'viewId': viewId,
      'quadrilateralJson': quadrilateralJson,
    };
    final result = await executeCore('CoreModule', 'viewQuadrilateralForFrameQuadrilateral', params);
    return result;
  }

  /// Registers persistent event listener for view events
  Future<void> registerListenerForViewEvents({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'registerListenerForViewEvents', params);
  }

  /// Unregisters the view event listener
  Future<void> unregisterListenerForViewEvents({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'unregisterListenerForViewEvents', params);
  }

  /// Registers a persistent listener for focus gesture events
  Future<void> registerFocusGestureListener({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'registerFocusGestureListener', params);
  }

  /// Unregisters the focus gesture event listener
  Future<void> unregisterFocusGestureListener({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'unregisterFocusGestureListener', params);
  }

  /// Triggers a focus as if the focus gesture was performed
  Future<void> triggerFocus({required int viewId, required String pointJson}) async {
    final params = {
      'viewId': viewId,
      'pointJson': pointJson,
    };
    return await executeCore('CoreModule', 'triggerFocus', params);
  }

  /// Triggers a zoom in gesture as if the zoom gesture was performed
  Future<void> triggerZoomIn({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'triggerZoomIn', params);
  }

  /// Triggers a zoom out gesture as if the zoom gesture was performed
  Future<void> triggerZoomOut({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'triggerZoomOut', params);
  }

  /// Registers a persistent listener for zoom gesture events
  Future<void> registerZoomGestureListener({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'registerZoomGestureListener', params);
  }

  /// Unregisters the zoom gesture event listener
  Future<void> unregisterZoomGestureListener({required int viewId}) async {
    final params = {
      'viewId': viewId,
    };
    return await executeCore('CoreModule', 'unregisterZoomGestureListener', params);
  }

  /// Updates the DataCaptureView configuration
  Future<void> updateDataCaptureView({required String viewJson}) async {
    final params = {
      'viewJson': viewJson,
    };
    return await executeCore('CoreModule', 'updateDataCaptureView', params);
  }

  /// Emits haptic/audio feedback
  Future<void> emitFeedback({required String feedbackJson}) async {
    final params = {
      'feedbackJson': feedbackJson,
    };
    return await executeCore('CoreModule', 'emitFeedback', params);
  }
}
