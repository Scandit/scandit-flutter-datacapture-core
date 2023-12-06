/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.common

import com.scandit.datacapture.core.data.FrameData
import com.scandit.datacapture.core.data.toJson
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

object LastFrameDataHolder {
    var frameData: FrameData? = null

    private var executorService: ExecutorService? = null

    @Synchronized
    fun handleGetRequest(result: MethodChannel.Result) {
        if (executorService == null) {
            executorService = Executors.newFixedThreadPool(1)
        }
        executorService?.execute {
            val jsonFrameData = frameData?.toJson()
            if (jsonFrameData == null) {
                result.error(
                    "100",
                    "Frame is null, it might've been reused already.",
                    null
                )
                return@execute
            }
            frameData = null
            result.success(jsonFrameData)
        }
    }

    @Synchronized
    fun release() {
        executorService?.shutdown()
        executorService = null
    }
}
