/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.listeners

import com.scandit.datacapture.core.json.JsonValue
import com.scandit.datacapture.core.source.Camera
import com.scandit.datacapture.core.source.CameraPosition
import com.scandit.datacapture.core.source.CameraPositionDeserializer
import com.scandit.datacapture.core.source.FrameSource
import com.scandit.datacapture.core.source.FrameSourceListener
import com.scandit.datacapture.core.source.FrameSourceState
import com.scandit.datacapture.core.source.FrameSourceStateDeserializer
import com.scandit.datacapture.core.source.TorchStateDeserializer
import com.scandit.datacapture.core.source.serialization.FrameSourceDeserializer
import com.scandit.datacapture.core.source.serialization.FrameSourceDeserializerListener
import com.scandit.datacapture.core.source.toJson
import com.scandit.datacapture.flutter.core.errors.CameraNotReadyError
import com.scandit.datacapture.flutter.core.errors.WrongCameraPositionError
import com.scandit.datacapture.flutter.core.utils.EventHandler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject

class ScanditFlutterFrameSourceListener(binaryMessenger: BinaryMessenger) :
    FrameSourceListener, FrameSourceDeserializerListener {

    companion object {
        private const val DESIRED_TORCH_STATE = "desiredTorchState"
        private const val DESIRED_STATE = "desiredState"
        private const val ON_STATE_CHANGED_EVENT_NAME = "didChangeState"
        private const val FIELD_EVENT = "event"
        private const val FIELD_STATE = "state"
        private const val CHANNEL_NAME = "com.scandit.datacapture.core.event/camera#didChangeState"
    }

    private val didChangeStateEventHandler = EventHandler(
        EventChannel(binaryMessenger, CHANNEL_NAME)
    )

    fun getCameraState(cameraPositionAsJson: String): String =
        try {
            val positionCamera = this.camera.takeIf {
                it?.position == getCameraPositionFromJson(cameraPositionAsJson)
            } ?: throw CameraNotReadyError()

            positionCamera.currentState.toJson()
        } catch (_: IllegalStateException) {
            throw CameraNotReadyError()
        }

    fun isTorchAvailable(cameraPositionAsJson: String): Boolean {
        try {
            val currentCamera = this.camera ?: throw CameraNotReadyError()
            if (currentCamera.position != getCameraPositionFromJson(cameraPositionAsJson)) {
                throw WrongCameraPositionError()
            }

            return currentCamera.isTorchAvailable
        } catch (_: IllegalStateException) {
            throw CameraNotReadyError()
        }
    }

    override fun onFrameSourceDeserializationFinished(
        deserializer: FrameSourceDeserializer,
        frameSource: FrameSource,
        json: JsonValue
    ) {
        camera = frameSource as? Camera ?: return

        camera?.let {
            if (json.contains(DESIRED_TORCH_STATE)) {
                it.desiredTorchState = TorchStateDeserializer.fromJson(
                    json.requireByKeyAsString(DESIRED_TORCH_STATE)
                )
            }

            if (json.contains(DESIRED_STATE)) {
                it.switchToDesiredState(
                    FrameSourceStateDeserializer.fromJson(
                        json.requireByKeyAsString(DESIRED_STATE)
                    )
                )
            }
        }
    }

    override fun onStateChanged(frameSource: FrameSource, newState: FrameSourceState) {
        didChangeStateEventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to ON_STATE_CHANGED_EVENT_NAME,
                    FIELD_STATE to newState.toJson()
                )
            )
        )
    }

    fun dispose() {
        camera = null
    }

    private var camera: Camera? = null
        private set(value) {
            field?.removeListener(this)
            field = value?.also { it.addListener(this) }
        }

    private fun getCameraPositionFromJson(json: String): CameraPosition =
        CameraPositionDeserializer.fromJson(json)
}
