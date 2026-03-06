/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.frameworks.core.result.FrameworksResult;
import com.scandit.datacapture.frameworks.core.utils.DefaultFrameworksLog;
import com.scandit.datacapture.frameworks.core.utils.FrameworksLog;

public class FlutterLogInsteadOfResult implements FrameworksResult {
    private final FrameworksLog logger;

    public FlutterLogInsteadOfResult() {
        this.logger = DefaultFrameworksLog.getInstance();
    }

    @Override
    public void success(@Nullable Object result) {
        // nop
    }

    @Override
    public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
        logger.error(
                String.format(
                        "ErrorCode: %1$s; ErrorMessage: %2$s; ErrorDetails: %3$s.",
                        errorCode,
                        errorMessage,
                        errorDetails)
        );
    }
}
