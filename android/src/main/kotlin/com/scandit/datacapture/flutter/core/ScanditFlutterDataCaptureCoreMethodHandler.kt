/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core

import android.content.Context
import com.scandit.datacapture.core.capture.DataCaptureContext
import com.scandit.datacapture.core.common.feedback.Feedback
import com.scandit.datacapture.core.common.geometry.*
import com.scandit.datacapture.core.source.Camera
import com.scandit.datacapture.core.source.CameraPosition
import com.scandit.datacapture.core.source.CameraSettings
import com.scandit.datacapture.core.source.toJson
import com.scandit.datacapture.core.ui.DataCaptureView
import com.scandit.datacapture.core.ui.style.Brush
import com.scandit.datacapture.core.ui.viewfinder.AimerViewfinder
import com.scandit.datacapture.core.ui.viewfinder.LaserlineViewfinder
import com.scandit.datacapture.core.ui.viewfinder.RectangularViewfinder
import com.scandit.datacapture.flutter.core.data.defaults.*
import com.scandit.datacapture.flutter.core.deserializers.DataCaptureContextLifecycleObserver
import com.scandit.datacapture.flutter.core.deserializers.Deserializers
import com.scandit.datacapture.flutter.core.errors.CameraNotReadyError
import com.scandit.datacapture.flutter.core.errors.WrongCameraPositionError
import com.scandit.datacapture.flutter.core.handler.DataCaptureViewHandler
import com.scandit.datacapture.flutter.core.listeners.ScanditFlutterDataCaptureContextListener
import com.scandit.datacapture.flutter.core.listeners.ScanditFlutterDataCaptureViewListener
import com.scandit.datacapture.flutter.core.listeners.ScanditFlutterFrameSourceListener
import com.scandit.datacapture.flutter.core.utils.Error
import com.scandit.datacapture.flutter.core.utils.EventHandler
import com.scandit.datacapture.flutter.core.utils.MainThreadUtil
import com.scandit.datacapture.flutter.core.utils.reject
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException

class ScanditFlutterDataCaptureCoreMethodHandler(
    private val context: Context,
    binaryMessenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {

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

        private val ERROR_DESERIALIZATION_FAILED = Error(1, "Unable to deserialize a valid object.")
        private val ERROR_NULL_VIEW = Error(2, "DataCaptureView is null")
        private val ERROR_CAMERA_NOT_READY = Error(3, "Camera has yet not been instantiated.")
        private val ERROR_WRONG_CAMERA_POSITION = Error(
            4,
            "CameraPosition argument does not " +
                    "match the position of the currently used camera."
        )
    }

    private val frameSourceDeserializerListener = ScanditFlutterFrameSourceListener(binaryMessenger)
    private val datacaptureViewListener = ScanditFlutterDataCaptureViewListener(
        EventHandler(
            EventChannel(binaryMessenger, ScanditFlutterDataCaptureViewListener.CHANNEL_NAME)
        )
    )
    private val dataCaptureContextListener =
        ScanditFlutterDataCaptureContextListener(
            didStartObservingEventHandler = EventHandler(
                EventChannel(
                    binaryMessenger,
                    ScanditFlutterDataCaptureContextListener.DID_START_OBSERVING_CONTEXT_CHANNEL
                )
            ),
            didChangeStatusEventHandler = EventHandler(
                EventChannel(
                    binaryMessenger,
                    ScanditFlutterDataCaptureContextListener.DID_CHANGE_STATUS_CHANNEL
                )
            )
        )

    private val defaults: SerializableCoreDefaults by lazy {
        val cameraSettings = CameraSettings()
        val dataCaptureView = DataCaptureView.newInstance(context, null)

        val availableCameraPositions = listOfNotNull(
            Camera.getCamera(CameraPosition.USER_FACING)?.position,
            Camera.getCamera(CameraPosition.WORLD_FACING)?.position
        )

        SerializableCoreDefaults(
            cameraDefaults = SerializableCameraDefaults(
                cameraSettingsDefaults = SerializableCameraSettingsDefaults(
                    settings = cameraSettings
                ),
                availablePositions = availableCameraPositions,
                defaultPosition = Camera.getDefaultCamera()?.position?.toJson()
            ),
            dataCaptureViewDefaults = SerializableDataCaptureViewDefaults(dataCaptureView),
            brushDefaults = SerializableBrushDefaults(Brush.transparent()),
            laserlineViewfinderDefaults =
            SerializableLaserlineViewfinderDefaults(LaserlineViewfinder()),
            rectangularViewfinderDefaults =
            SerializableRectangularViewfinderDefaults(RectangularViewfinder()),
            aimerViewFinderDefaults = SerializableAimerViewfinderDefaults(AimerViewfinder())
        )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_DEFAULTS ->
                result.success(defaults.toJson().toString())

            METHOD_CONTEXT_FROM_JSON -> {
                val contextJson = call.arguments as String
                contextFromJSON(contextJson, result)
            }
            METHOD_UPDATE_CONTEXT_FROM_JSON -> {
                val contextJson = call.arguments as String
                updateContextFromJSON(contextJson, result)
            }
            METHOD_GET_CAMERA_STATE -> {
                val cameraPosition = call.arguments as String
                getCameraState(cameraPosition, result)
            }
            METHOD_IS_TORCH_AVAILABLE -> {
                val cameraPosition = call.arguments as String
                isTorchAvailable(cameraPosition, result)
            }
            METHOD_EMIT_FEEDBACK -> emitFeedback(call.arguments as String, result)
            METHOD_VIEW_POINT_FOR_FRAME_POINT ->
                viewPointForFramePoint(call.arguments as String, result)
            METHOD_VIEW_QUADRILATERAL_FOR_FRAME_QUADRILATERAL ->
                viewQuadrilateralForFrameQuadrilateral(call.arguments as String, result)
            else ->
                result.notImplemented()
        }
    }

    private var latestFeedback: Feedback? = null

    private fun emitFeedback(feedbackAsJson: String, result: MethodChannel.Result) {
        try {
            Feedback.fromJson(feedbackAsJson).also {
                latestFeedback?.release()
                it.emit()
                latestFeedback = it
            }

            MainThreadUtil.runOnMainThread {
                result.success(null)
            }
        } catch (e: JSONException) {
            result.reject(e)
        }
    }

    private fun viewPointForFramePoint(json: String, result: MethodChannel.Result) {
        val view = DataCaptureViewHandler.dataCaptureView ?: run {
            result.reject(ERROR_NULL_VIEW)
            return
        }

        try {
            val mappedPoint = view.mapFramePointToView(
                PointDeserializer.fromJson(json)
            ).densityIndependent
            result.success(mappedPoint.toJson())
        } catch (e: RuntimeException) {
            result.reject(ERROR_DESERIALIZATION_FAILED)
        }
    }

    private val Point.densityIndependent: Point
        get() {
            val density = context.resources.displayMetrics.density
            return Point(x / density, y / density)
        }

    private fun viewQuadrilateralForFrameQuadrilateral(json: String, result: MethodChannel.Result) {
        val view = DataCaptureViewHandler.dataCaptureView ?: run {
            result.reject(ERROR_NULL_VIEW)
            return
        }

        try {
            val mappedQuadrilateral = view.mapFrameQuadrilateralToView(
                QuadrilateralDeserializer.fromJson(json)
            ).densityIndependent
            result.success(mappedQuadrilateral.toJson())
        } catch (e: RuntimeException) {
            result.reject(ERROR_DESERIALIZATION_FAILED)
        }
    }

    private val Quadrilateral.densityIndependent: Quadrilateral
        get() = Quadrilateral(
            topLeft.densityIndependent,
            topRight.densityIndependent,
            bottomRight.densityIndependent,
            bottomLeft.densityIndependent
        )

    private fun getCameraState(cameraPosition: String, result: MethodChannel.Result) {
        try {
            result.success(frameSourceDeserializerListener.getCameraState(cameraPosition))
        } catch (_: CameraNotReadyError) {
            result.reject(ERROR_CAMERA_NOT_READY)
        }
    }

    private fun isTorchAvailable(cameraPosition: String, result: MethodChannel.Result) {
        try {
            result.success(frameSourceDeserializerListener.isTorchAvailable(cameraPosition))
        } catch (_: CameraNotReadyError) {
            result.reject(ERROR_CAMERA_NOT_READY)
        } catch (_: WrongCameraPositionError) {
            result.reject(ERROR_WRONG_CAMERA_POSITION)
        }
    }

    fun dispose() {
        dataCaptureContext = null
        frameSourceDeserializerListener.dispose()
    }

    private val deserializers: Deserializers by lazy {
        Deserializers.Factory.create(context, frameSourceDeserializerListener)
    }

    private var dataCaptureContext: DataCaptureContext? = null
        private set(value) {
            field?.removeListener(dataCaptureContextListener)
            field?.release()
            field = value?.also { it.addListener(dataCaptureContextListener) }
        }

    private fun contextFromJSON(json: String, result: MethodChannel.Result) {
        dispose()

        try {
            val deserializerResult =
                deserializers.dataCaptureContextDeserializer.contextFromJson(json)

            dataCaptureContext = deserializerResult.dataCaptureContext

            DataCaptureViewHandler.dataCaptureView = deserializerResult.view?.also {
                it.addListener(datacaptureViewListener)
            }

            result.success(null)
        } catch (e: AssertionError) {
            result.reject(e)
        } catch (e: JSONException) {
            result.reject(e)
        } catch (@Suppress("TooGenericExceptionCaught") e: RuntimeException) {
            result.reject(e)
        }
    }

    private fun updateContextFromJSON(json: String, result: MethodChannel.Result) {
        dataCaptureContext?.let { dataCaptureContext ->
            // Parsers are re-created during the update. Avoid keeping stale ones.
            DataCaptureContextLifecycleObserver.dispatchParsersRemoved()

            val updateResult = deserializers.dataCaptureContextDeserializer.updateContextFromJson(
                dataCaptureContext,
                DataCaptureViewHandler.dataCaptureView,
                emptyList(),
                json
            )

            DataCaptureViewHandler.dataCaptureView?.removeListener(datacaptureViewListener)

            DataCaptureViewHandler.dataCaptureView = updateResult.view?.also {
                it.addListener(datacaptureViewListener)
            }

            result.success(null)
            return
        }

        // Since dataCaptureContext is null, initialize it instead of updating it.
        contextFromJSON(json, result)
    }
}
