package com.scandit.datacapture.flutter.core.utils

import com.scandit.datacapture.frameworks.core.result.FrameworksResult
import io.flutter.plugin.common.MethodChannel

class FlutterResult(private val result: MethodChannel.Result) : FrameworksResult {
    override fun success(result: Any?) {
        this.result.success(result)
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        this.result.error(errorCode, errorMessage, errorDetails)
    }
}
