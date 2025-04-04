/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

import io.flutter.plugin.common.MethodChannel;

public class ResultUtils {
    public static void reject(MethodChannel.Result result, Error error) {
        result.error(String.valueOf(error.code), error.message, null);
    }

    public static void reject(MethodChannel.Result result, Error error, Object... messageArgs) {
        result.error(String.valueOf(error.code), String.format(error.message, messageArgs), null);
    }

    public static void rejectKotlinError(MethodChannel.Result result, java.lang.Error error) {
        result.error("-1", error.getMessage(), error.getCause());
    }
}
