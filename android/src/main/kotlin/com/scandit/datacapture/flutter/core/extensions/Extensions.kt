/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.extensions

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

fun FlutterPlugin.FlutterPluginBinding.getMethodChannel(channelName: String): MethodChannel {
    return MethodChannel(
        binaryMessenger,
        channelName
    )
}
