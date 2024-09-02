package com.scandit.datacapture.flutter.core.utils

import com.scandit.datacapture.frameworks.core.result.FrameworksResult
import com.scandit.datacapture.frameworks.core.utils.DefaultFrameworksLog
import com.scandit.datacapture.frameworks.core.utils.FrameworksLog
import io.flutter.plugin.common.MethodChannel

class FlutterResult(private val result: MethodChannel.Result) : FrameworksResult {
    override fun success(result: Any?) {
        this.result.success(result)
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        this.result.error(errorCode, errorMessage, errorDetails)
    }
}

class FlutterLogInsteadOfResult(
    private val logger: FrameworksLog = DefaultFrameworksLog.getInstance()
) : FrameworksResult {
    override fun success(result: Any?) {
        // nop
    }

    override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
        logger.error(
            "ErrorCode: $errorCode; ErrorMessage:$errorMessage; ErrorDetails:$errorDetails"
        )
    }
}
