/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils

import android.os.Handler
import android.os.Looper

internal object MainThreadUtil {

    private var mainHandler: Handler? = null

    fun isOnMainThread(): Boolean = Looper.getMainLooper().thread === Thread.currentThread()

    fun runOnMainThread(lambda: () -> Unit) {
        if (isOnMainThread()) {
            lambda()
        } else {
            postOnMainThread(lambda)
        }
    }

    private fun postOnMainThread(lambda: () -> Unit) {
        if (mainHandler == null) {
            synchronized(this) {
                if (mainHandler == null) {
                    mainHandler = Handler(Looper.getMainLooper())
                }
            }
        }
        mainHandler?.post(lambda)
    }
}
