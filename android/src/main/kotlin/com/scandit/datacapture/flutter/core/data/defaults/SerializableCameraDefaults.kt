/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.source.CameraPosition
import com.scandit.datacapture.core.source.toJson
import com.scandit.datacapture.flutter.core.data.SerializableData
import org.json.JSONArray
import org.json.JSONObject

data class SerializableCameraDefaults(
    private val cameraSettingsDefaults: SerializableCameraSettingsDefaults,
    private val defaultPosition: String?,
    private val availablePositions: List<CameraPosition>
) : SerializableData {

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_CAMERA_SETTINGS_DEFAULTS to cameraSettingsDefaults.toJson(),
            FIELD_DEFAULT_POSITION to defaultPosition,
            FIELD_AVAILABLE_POSITIONS to JSONArray(availablePositions.map { it.toJson() })
        )
    )

    companion object {
        private const val FIELD_CAMERA_SETTINGS_DEFAULTS = "Settings"
        private const val FIELD_DEFAULT_POSITION = "defaultPosition"
        private const val FIELD_AVAILABLE_POSITIONS = "availablePositions"
    }
}
