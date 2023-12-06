/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.listeners

import com.scandit.datacapture.core.capture.DataCaptureContext
import com.scandit.datacapture.core.capture.DataCaptureContextListener
import com.scandit.datacapture.core.common.ContextStatus
import com.scandit.datacapture.core.common.toJson
import com.scandit.datacapture.flutter.core.utils.EventHandler
import org.json.JSONObject

class ScanditFlutterDataCaptureContextListener(
    private val didStartObservingEventHandler: EventHandler,
    private val didChangeStatusEventHandler: EventHandler
) :
    DataCaptureContextListener {

    companion object {
        const val DID_START_OBSERVING_CONTEXT_CHANNEL =
            "com.scandit.datacapture.core.event/datacapture_context#didStartObservingContext"
        const val DID_CHANGE_STATUS_CHANNEL =
            "com.scandit.datacapture.core.event/datacapture_context#didChangeStatus"

        private const val FIELD_STATUS = "status"
        private const val FIELD_LICENCE_INFO = "licenseInfo"
        private const val FIELD_EVENT = "event"
    }

    override fun onObservationStarted(dataCaptureContext: DataCaptureContext) {
        didStartObservingEventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to DID_START_OBSERVING_CONTEXT_CHANNEL,
                    FIELD_LICENCE_INFO to dataCaptureContext.licenseInfo?.toJson()
                )
            )
        )
    }

    override fun onStatusChanged(
        dataCaptureContext: DataCaptureContext,
        contextStatus: ContextStatus
    ) {
        didChangeStatusEventHandler.send(
            JSONObject(
                mapOf(
                    FIELD_EVENT to DID_CHANGE_STATUS_CHANNEL,
                    FIELD_STATUS to contextStatus.toJson()
                )
            )
        )
    }
}
