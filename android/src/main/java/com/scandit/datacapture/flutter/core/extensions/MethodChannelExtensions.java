/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.extensions;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodChannel;

public class MethodChannelExtensions {
    public static MethodChannel getMethodChannel(FlutterPlugin.FlutterPluginBinding binding, String channelName) {
        return new MethodChannel(binding.getBinaryMessenger(), channelName);
    }
}
