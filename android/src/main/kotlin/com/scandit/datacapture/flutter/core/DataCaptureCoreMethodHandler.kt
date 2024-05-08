/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core

import com.scandit.datacapture.flutter.core.utils.FlutterResult
import com.scandit.datacapture.frameworks.core.CoreModule
import com.scandit.datacapture.frameworks.core.utils.DefaultMainThread
import com.scandit.datacapture.frameworks.core.utils.MainThread
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class DataCaptureCoreMethodHandler(
    private val coreModule: CoreModule,
    private val mainThread: MainThread = DefaultMainThread.getInstance()
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_DEFAULTS -> result.success(JSONObject(coreModule.getDefaults()).toString())

            METHOD_CONTEXT_FROM_JSON -> {
                val contextJson = call.arguments as String
                coreModule.createContextFromJson(contextJson, FlutterResult(result))
            }

            METHOD_UPDATE_CONTEXT_FROM_JSON -> {
                val contextJson = call.arguments as String
                mainThread.runOnMainThread {
                    coreModule.updateContextFromJson(contextJson, FlutterResult(result))
                }
            }

            METHOD_GET_CAMERA_STATE -> {
                val cameraPosition = call.arguments as String
                coreModule.getCameraState(cameraPosition, FlutterResult(result))
            }

            METHOD_IS_TORCH_AVAILABLE -> {
                val cameraPosition = call.arguments as String
                coreModule.isTorchAvailable(cameraPosition, FlutterResult(result))
            }

            METHOD_EMIT_FEEDBACK ->
                coreModule.emitFeedback(call.arguments as String, FlutterResult(result))

            METHOD_VIEW_POINT_FOR_FRAME_POINT ->
                coreModule.viewPointForFramePoint(call.arguments as String, FlutterResult(result))

            METHOD_VIEW_QUADRILATERAL_FOR_FRAME_QUADRILATERAL ->
                coreModule.viewQuadrilateralForFrameQuadrilateral(
                    call.arguments as String,
                    FlutterResult(result)
                )

            METHOD_SWITCH_CAMERA_TO_DESIRED_STATE ->
                coreModule.switchCameraToDesiredState(
                    call.arguments as String,
                    FlutterResult(result)
                )

            METHOD_ADD_MODE_TO_CONTEXT ->
                coreModule.addModeToContext(call.arguments as String, FlutterResult(result))

            METHOD_REMOVE_MODE_FROM_CONTEXT ->
                coreModule.removeModeFromContext(call.arguments as String, FlutterResult(result))

            METHOD_REMOVE_ALL_MODES_FROM_CONTEXT -> coreModule.removeAllModes(FlutterResult(result))

            METHOD_UPDATE_DC_VIEW -> coreModule.updateDataCaptureView(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_ADD_OVERLAY -> coreModule.addOverlayToView(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_REMOVE_OVERLAY -> coreModule.removeOverlayFromView(
                call.arguments as String,
                FlutterResult(result)
            )

            METHOD_REMOVE_ALL_OVERLAYS -> coreModule.removeAllOverlays(FlutterResult(result))
            else ->
                result.notImplemented()
        }
    }

    companion object {
        private const val METHOD_GET_DEFAULTS = "getDefaults"
        private const val METHOD_CONTEXT_FROM_JSON = "createContextFromJSON"
        private const val METHOD_UPDATE_CONTEXT_FROM_JSON = "updateContextFromJSON"
        private const val METHOD_GET_CAMERA_STATE = "getCameraState"
        private const val METHOD_IS_TORCH_AVAILABLE = "isTorchAvailable"
        private const val METHOD_EMIT_FEEDBACK = "emitFeedback"
        private const val METHOD_VIEW_POINT_FOR_FRAME_POINT = "viewPointForFramePoint"
        private const val METHOD_VIEW_QUADRILATERAL_FOR_FRAME_QUADRILATERAL =
            "viewQuadrilateralForFrameQuadrilateral"
        private const val METHOD_SWITCH_CAMERA_TO_DESIRED_STATE = "switchCameraToDesiredState"
        private const val METHOD_ADD_MODE_TO_CONTEXT = "addModeToContext"
        private const val METHOD_REMOVE_MODE_FROM_CONTEXT = "removeModeFromContext"
        private const val METHOD_REMOVE_ALL_MODES_FROM_CONTEXT = "removeAllModesFromContext"
        private const val METHOD_UPDATE_DC_VIEW = "updateDataCaptureView"
        private const val METHOD_ADD_OVERLAY = "addOverlay"
        private const val METHOD_REMOVE_OVERLAY = "removeOverlay"
        private const val METHOD_REMOVE_ALL_OVERLAYS = "removeAllOverlays"
    }
}
