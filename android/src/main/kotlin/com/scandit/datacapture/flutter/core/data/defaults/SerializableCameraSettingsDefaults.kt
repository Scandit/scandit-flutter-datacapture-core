/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.source.CameraSettings
import com.scandit.datacapture.core.source.toJson
import com.scandit.datacapture.flutter.core.data.SerializableData
import org.json.JSONObject

data class SerializableCameraSettingsDefaults(
    private val prefResolution: String,
    private val zoomFactor: Float,
    private val focusRange: String,
    private val focusGestureStrategy: String,
    private val zoomGestureZoomFactor: Float,
    private val shouldPreferSmoothAutoFocus: Boolean
) : SerializableData {

    constructor(settings: CameraSettings) : this(
        prefResolution = settings.preferredResolution.toJson(),
        zoomFactor = settings.zoomFactor,
        focusRange = "full",
        focusGestureStrategy = settings.focusGestureStrategy.toJson(),
        zoomGestureZoomFactor = settings.zoomGestureZoomFactor,
        shouldPreferSmoothAutoFocus = settings.shouldPreferSmoothAutoFocus
    )

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_PREFERRED_RESOLUTION to prefResolution,
            FIELD_ZOOM_FACTOR to zoomFactor,
            FIELD_FOCUS_RANGE to focusRange,
            FIELD_FOCUS_GESTURE_STRATEGY to focusGestureStrategy,
            FIELD_ZOOM_GESTURE_ZOOM_FACTOR to zoomGestureZoomFactor,
            FIELD_SHOULD_PREFER_SMOOTH_AUTO_FOCUS to shouldPreferSmoothAutoFocus
        )
    )

    companion object {
        private const val FIELD_PREFERRED_RESOLUTION = "preferredResolution"
        private const val FIELD_ZOOM_FACTOR = "zoomFactor"
        private const val FIELD_FOCUS_RANGE = "focusRange"
        private const val FIELD_FOCUS_GESTURE_STRATEGY = "focusGestureStrategy"
        private const val FIELD_ZOOM_GESTURE_ZOOM_FACTOR = "zoomGestureZoomFactor"
        private const val FIELD_SHOULD_PREFER_SMOOTH_AUTO_FOCUS = "shouldPreferSmoothAutoFocus"
    }
}
