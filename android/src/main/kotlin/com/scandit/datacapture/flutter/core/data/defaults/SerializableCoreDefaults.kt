/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.capture.DataCaptureContext
import com.scandit.datacapture.core.capture.DataCaptureVersion
import com.scandit.datacapture.flutter.core.data.SerializableData
import org.json.JSONObject

data class SerializableCoreDefaults(
    private val cameraDefaults: SerializableCameraDefaults,
    private val dataCaptureViewDefaults: SerializableDataCaptureViewDefaults,
    private val laserlineViewfinderDefaults: SerializableLaserlineViewfinderDefaults,
    private val rectangularViewfinderDefaults: SerializableRectangularViewfinderDefaults,
    private val brushDefaults: SerializableBrushDefaults,
    private val aimerViewFinderDefaults: SerializableAimerViewfinderDefaults
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_VERSION to DataCaptureVersion.VERSION_STRING,
            FIELD_CAMERA_DEFAULTS to cameraDefaults.toJson(),
            FIELD_DATA_CAPTURE_VIEW_DEFAULTS to dataCaptureViewDefaults.toJson(),
            FIELD_LASERLINE_VIEW_FINDER_DEFAULTS to laserlineViewfinderDefaults.toJson(),
            FIELD_RECTANGULAR_VIEW_FINDER_DEFAULTS to rectangularViewfinderDefaults.toJson(),
            FIELD_BRUSH_DEFAULTS to brushDefaults.toJson(),
            FIELD_DEVICE_ID to DataCaptureContext.DEVICE_ID,
            FIELD_AIMER_VIEW_FINDER_DEFAULTS to aimerViewFinderDefaults.toJson()
        )
    )

    companion object {
        private const val FIELD_VERSION = "Version"
        private const val FIELD_CAMERA_DEFAULTS = "Camera"
        private const val FIELD_DATA_CAPTURE_VIEW_DEFAULTS = "DataCaptureView"
        private const val FIELD_LASERLINE_VIEW_FINDER_DEFAULTS = "LaserlineViewfinder"
        private const val FIELD_RECTANGULAR_VIEW_FINDER_DEFAULTS = "RectangularViewfinder"
        private const val FIELD_BRUSH_DEFAULTS = "Brush"
        private const val FIELD_DEVICE_ID = "DeviceId"
        private const val FIELD_AIMER_VIEW_FINDER_DEFAULTS = "AimerViewfinder"
    }
}
