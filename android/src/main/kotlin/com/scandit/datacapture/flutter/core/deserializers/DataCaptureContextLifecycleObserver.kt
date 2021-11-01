package com.scandit.datacapture.flutter.core.deserializers

object DataCaptureContextLifecycleObserver {
    val callbacks = mutableListOf<Callbacks>()

    internal fun dispatchParsersRemoved() {
        callbacks.forEach { it.onParsersRemoved() }
    }

    interface Callbacks {
        fun onParsersRemoved() = Unit
    }
}
