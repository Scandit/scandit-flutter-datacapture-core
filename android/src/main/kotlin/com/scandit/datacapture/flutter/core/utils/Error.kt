/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils

import io.flutter.plugin.common.MethodChannel.Result

data class Error(val code: Int, val message: String)

fun Result.reject(throwable: Throwable) {
    error("0", throwable.message, null)
}

fun Result.reject(error: Error) {
    error(error.code.toString(), error.message, null)
}

fun Result.reject(error: Error, vararg messageArgs: Any?) {
    error(error.code.toString(), error.message.format(messageArgs.joinToString(" ")), null)
}
