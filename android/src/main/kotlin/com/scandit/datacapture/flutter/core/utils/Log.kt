/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils

internal object Log {
    private const val TAG = "sdc-flutter"

    @JvmStatic
    fun error(message: String) {
        android.util.Log.e(TAG, message)
    }

    @JvmStatic
    fun info(message: String) {
        android.util.Log.i(TAG, message)
    }

    @JvmStatic
    fun error(e: Exception) {
        e.printStackTrace()
    }

    @JvmStatic
    fun error(message: String, e: Exception) {
        android.util.Log.e(TAG, message)
        e.printStackTrace()
    }
}
