/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.deserializers

import android.content.Context
import com.scandit.datacapture.core.capture.serialization.DataCaptureContextDeserializer
import com.scandit.datacapture.core.capture.serialization.DataCaptureModeDeserializer
import com.scandit.datacapture.core.component.serialization.DataCaptureComponentDeserializer
import com.scandit.datacapture.core.source.serialization.FrameSourceDeserializer
import com.scandit.datacapture.core.source.serialization.FrameSourceDeserializerListener
import com.scandit.datacapture.core.ui.serialization.DataCaptureViewDeserializer

class Deserializers private constructor(
    context: Context,
    modeDeserializers: List<DataCaptureModeDeserializer>,
    componentDeserializers: List<DataCaptureComponentDeserializer>,
    frameSourceDeserializerListener: FrameSourceDeserializerListener
) {
    object Factory {
        private val modeDeserializers = mutableListOf<DataCaptureModeDeserializer>()
        private val componentDeserializers = mutableListOf<DataCaptureComponentDeserializer>()

        fun addModeDeserializer(deserializer: DataCaptureModeDeserializer) {
            modeDeserializers += deserializer
        }

        fun addComponentDeserializer(deserializer: DataCaptureComponentDeserializer) {
            componentDeserializers += deserializer
        }

        fun removeModeDeserializer(deserializer: DataCaptureModeDeserializer) {
            modeDeserializers -= deserializer
        }

        fun removeComponentDeserializer(deserializer: DataCaptureComponentDeserializer) {
            componentDeserializers -= deserializer
        }

        fun clearDeserializers() {
            modeDeserializers.clear()
            componentDeserializers.clear()
        }

        fun create(
            context: Context,
            frameSourceDeserializerListener:
                FrameSourceDeserializerListener
        ): Deserializers {
            return Deserializers(
                context,
                modeDeserializers,
                componentDeserializers,
                frameSourceDeserializerListener
            )
        }
    }

    private val frameSourceDeserializer: FrameSourceDeserializer =
        FrameSourceDeserializer(modeDeserializers).apply {
            listener = frameSourceDeserializerListener
        }
    private val dataCaptureViewDeserializer: DataCaptureViewDeserializer =
        DataCaptureViewDeserializer(context, modeDeserializers)

    val dataCaptureContextDeserializer: DataCaptureContextDeserializer =
        DataCaptureContextDeserializer(
            frameSourceDeserializer,
            dataCaptureViewDeserializer,
            modeDeserializers,
            componentDeserializers
        ).apply {
            avoidThreadDependencies = true
        }
}
