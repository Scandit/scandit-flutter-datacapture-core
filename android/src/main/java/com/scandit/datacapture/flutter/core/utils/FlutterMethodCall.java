/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

import androidx.annotation.NonNull;

import com.scandit.datacapture.frameworks.core.method.FrameworksMethodCall;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.Collections;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.MethodCall;

public class FlutterMethodCall implements FrameworksMethodCall {

    private final MethodCall call;

    public FlutterMethodCall(@NonNull MethodCall call) {
        this.call = call;
    }

    @NonNull
    @Override
    public String getMethod() {
        return call.method;
    }

    @Override
    @SuppressWarnings("unchecked")
    public <T> T argument(@NonNull String key) {
        Object value = call.argument(key);
        return (T) convertNumber(value);
    }

    @Override
    public boolean hasArgument(@NonNull String key) {
        return call.hasArgument(key);
    }


    @Override
    public @NotNull Map<@NotNull String, @Nullable Object> arguments() {
        return Objects.requireNonNull(call.arguments());
    }

    @Nullable
    private Object convertNumber(@Nullable Object value) {
        if (!(value instanceof Number)) {
            return value;
        }

        Number number = (Number) value;

        if (value instanceof Double) {
            double d = number.doubleValue();
            if (d == Math.floor(d) && !Double.isInfinite(d)) {
                long longValue = number.longValue();
                if (longValue >= Integer.MIN_VALUE && longValue <= Integer.MAX_VALUE) {
                    return (int) longValue;
                }
                return longValue;
            }
        }
        
        return value;
    }
}
