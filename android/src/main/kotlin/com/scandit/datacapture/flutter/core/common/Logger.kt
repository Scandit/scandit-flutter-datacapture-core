package com.scandit.datacapture.flutter.core.common

object Logger {
    private const val TAG = "scandit-flutter"
    fun error(message: String) {
        android.util.Log.e(TAG, message)
    }
}
