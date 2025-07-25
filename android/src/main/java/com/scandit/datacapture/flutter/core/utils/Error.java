/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

public class Error {
    public final int code;
    public final String message;

    public Error(int code, String message) {
        this.code = code;
        this.message = message;
    }
}

