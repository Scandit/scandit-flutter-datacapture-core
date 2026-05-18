/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.utils.FlutterResult;
import com.scandit.datacapture.frameworks.core.CoreModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.core.utils.DefaultMainThread;
import com.scandit.datacapture.frameworks.core.utils.MainThread;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.json.JSONObject;

import com.scandit.datacapture.flutter.core.utils.FlutterMethodCall;

public class DataCaptureCoreMethodHandler implements MethodChannel.MethodCallHandler {

    public static final String EVENT_CHANNEL_NAME = "com.scandit.datacapture.core/event_channel";

    public static final String METHOD_CHANNEL_NAME = "com.scandit.datacapture.core/method_channel";

    private final ServiceLocator<FrameworkModule> serviceLocator;
    private final MainThread mainThread;

    public DataCaptureCoreMethodHandler(ServiceLocator<FrameworkModule> serviceLocator) {
        this(serviceLocator, DefaultMainThread.getInstance());
    }

    public DataCaptureCoreMethodHandler(ServiceLocator<FrameworkModule> serviceLocator, MainThread mainThread) {
        this.serviceLocator = serviceLocator;
        this.mainThread = mainThread;
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "getDefaults":
                result.success(new JSONObject(getSharedModule().getDefaults()).toString());
                break;

            case "executeCore":
                assert call.arguments() != null;
                CoreModule module = getSharedModule();
                boolean handled = module.execute(
                        new FlutterMethodCall(call),
                        new FlutterResult(result),
                        module
                );
                if (!handled) {
                    result.error("METHOD_NOT_FOUND", "Unknown Core method", null);
                }
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    private volatile CoreModule module;

    private CoreModule getSharedModule() {
        if (module == null) {
            synchronized (this) {
                if (module == null) {
                    module = (CoreModule) this.serviceLocator.resolve(CoreModule.class.getSimpleName());
                }
            }
        }
        return module;
    }
}
