/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.listeners

import com.scandit.datacapture.core.ui.DataCaptureViewListener
import com.scandit.datacapture.core.ui.orientation.DeviceOrientationMapper
import com.scandit.datacapture.core.ui.orientation.toJson
import com.scandit.datacapture.flutter.core.utils.EventHandler
import org.json.JSONObject

class ScanditFlutterDataCaptureViewListener(
    private val didChangeSizeEventHandler: EventHandler
) : DataCaptureViewListener {
    companion object {
        private const val ON_SIZE_CHANGED_EVENT_NAME = "didChangeSize"
        private const val FIELD_EVENT = "event"
        private const val FIELD_SIZE = "size"
        private const val FIELD_WIDTH = "width"
        private const val FIELD_HEIGHT = "height"
        private const val FIELD_ORIENTATION = "orientation"

        const val CHANNEL_NAME = "com.scandit.datacapture.core.event/datacapture_view#didChangeSize"
    }

    override fun onSizeChanged(width: Int, height: Int, screenRotation: Int) {
        didChangeSizeEventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to ON_SIZE_CHANGED_EVENT_NAME,
                    FIELD_SIZE to mapOf(
                        FIELD_WIDTH to width,
                        FIELD_HEIGHT to height
                    ),
                    FIELD_ORIENTATION to DeviceOrientationMapper()
                        .mapRotationToOrientation(screenRotation).toJson()
                )
            )
        )
    }
}
