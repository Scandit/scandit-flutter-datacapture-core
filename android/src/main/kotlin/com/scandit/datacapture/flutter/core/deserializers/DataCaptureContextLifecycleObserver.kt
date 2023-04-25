package com.scandit.datacapture.flutter.core.deserializers

import com.scandit.datacapture.core.capture.DataCaptureContext

object DataCaptureContextLifecycleObserver {
    val callbacks = mutableListOf<Callbacks>()

    internal fun dispatchParsersRemoved() {
        callbacks.forEach { it.onParsersRemoved() }
    }

    internal fun dispatchDataCaptureContextUpdate(dataCaptureContext: DataCaptureContext?) {
        callbacks.forEach { it.onDataCaptureContextUpdated(dataCaptureContext) }
    }

    interface Callbacks {
        fun onParsersRemoved() { }
        fun onDataCaptureContextUpdated(dataCaptureContext: DataCaptureContext?) {}
    }
}
