/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2022- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.common

import com.scandit.datacapture.core.data.FrameData
import com.scandit.datacapture.core.data.toJson
import io.flutter.plugin.common.MethodChannel

object LastFrameDataHolder {
    var frameData: FrameData? = null

    fun handleGetRequest(result: MethodChannel.Result) {
        val frameData = LastFrameDataHolder.frameData?.toJson()
        if (frameData == null) {
            result.error(
                "100",
                "Frame is null, it might've been reused already.",
                null
            )
            return
        }
        result.success(frameData)
    }
}
