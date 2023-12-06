/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.data.defaults

import com.scandit.datacapture.core.common.geometry.toJson
import com.scandit.datacapture.core.ui.DataCaptureView
import com.scandit.datacapture.core.ui.serialization.toJson
import com.scandit.datacapture.flutter.core.data.SerializableData
import org.json.JSONObject

data class SerializableDataCaptureViewDefaults(
    private val scanAreaMargins: String,
    private val pointOfInterest: String,
    private val logoAnchor: String,
    private val logoOffset: String,
    private val logoStyle: String,
    private val focusGesture: String?,
    private val zoomGesture: String?
) : SerializableData {

    constructor(dataCaptureView: DataCaptureView) : this(
        scanAreaMargins = dataCaptureView.scanAreaMargins.toJson(),
        pointOfInterest = dataCaptureView.pointOfInterest.toJson(),
        logoAnchor = dataCaptureView.logoAnchor.toJson(),
        logoOffset = dataCaptureView.logoOffset.toJson(),
        logoStyle = dataCaptureView.logoStyle.toJson(),
        focusGesture = dataCaptureView.focusGesture?.toJson(),
        zoomGesture = dataCaptureView.zoomGesture?.toJson()
    )

    override fun toJson(): JSONObject = JSONObject(
        mapOf(
            FIELD_MARGINS to scanAreaMargins,
            FIELD_POI to pointOfInterest,
            FIELD_LOGO_ANCHOR to logoAnchor,
            FIELD_LOGO_OFFSET to logoOffset,
            FIELD_FOCUS_GESTURE to focusGesture,
            FIELD_ZOOM_GESTURE to zoomGesture,
            FIELD_LOGO_STYLE to logoStyle
        )
    )

    companion object {
        private const val FIELD_MARGINS = "scanAreaMargins"
        private const val FIELD_POI = "pointOfInterest"
        private const val FIELD_LOGO_ANCHOR = "logoAnchor"
        private const val FIELD_LOGO_OFFSET = "logoOffset"
        private const val FIELD_FOCUS_GESTURE = "focusGesture"
        private const val FIELD_ZOOM_GESTURE = "zoomGesture"
        private const val FIELD_LOGO_STYLE = "logoStyle"
    }
}
