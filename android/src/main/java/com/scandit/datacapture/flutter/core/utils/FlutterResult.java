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

import java.util.List;

import io.flutter.plugin.common.MethodChannel;

public class FlutterResult implements FrameworksResult {
    private final MethodChannel.Result result;

    public FlutterResult(MethodChannel.Result result) {
        this.result = result;
    }

    @Override
    public void success(@Nullable Object result) {
        this.result.success(result);
    }

    @Override
    public void error(@NonNull String errorCode, @Nullable String errorMessage, @Nullable Object errorDetails) {
        this.result.error(errorCode, errorMessage, errorDetails);
    }

    @Override
    public void successAndKeepCallback(@Nullable Object result) {
        success(result);
    }

    @Override
    public void registerCallbackForEvents(@NonNull List<String> eventNames) {
        // nop
    }

    @Override
    public void unregisterCallbackForEvents(@NonNull List<String> eventNames) {
        // nop
    }

    @Override
    public void registerModeSpecificCallback(int modeId, @NonNull List<String> eventNames) {
        // nop
    }

    @Override
    public void unregisterModeSpecificCallback(int modeId, @NonNull List<String> eventNames) {
        // nop
    }

    @Override
    public void registerViewSpecificCallback(int viewId, @NonNull List<String> eventNames) {
        // nop
    }

    @Override
    public void unregisterViewSpecificCallback(int viewId, @NonNull List<String> eventNames) {
        // nop
    }
}


