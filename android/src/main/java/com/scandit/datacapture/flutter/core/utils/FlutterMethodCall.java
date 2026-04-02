/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

import androidx.annotation.NonNull;

import com.scandit.datacapture.frameworks.core.method.FrameworksMethodCall;

import io.flutter.plugin.common.MethodCall;

public class FlutterMethodCall implements FrameworksMethodCall {

    private final MethodCall call;

    public FlutterMethodCall(@NonNull MethodCall call) {
        this.call = call;
    }

    @Override
    public String getMethod() {
        return call.method;
    }

    @Override
    public Object getArguments() {
        return call.arguments;
    }

    @Override
    public <T> T arguments() {
        return call.arguments();
    }

    @Override
    public <T> T argument(String key) {
        return call.argument(key);
    }

    @Override
    public boolean hasArgument(String key) {
        return call.hasArgument(key);
    }
}
