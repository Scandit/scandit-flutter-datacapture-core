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

            case "createContextFromJSON":
                assert call.arguments() != null;
                getSharedModule().createContextFromJson(call.arguments(), new FlutterResult(result));
                break;

            case "updateContextFromJSON":
                mainThread.runOnMainThread(() -> {
                    assert call.arguments() != null;
                    getSharedModule().updateContextFromJson(call.arguments(), new FlutterResult(result));
                });
                break;

            case "getCameraState":
                assert call.arguments() != null;
                getSharedModule().getCameraState(call.arguments(), new FlutterResult(result));
                break;

            case "isTorchAvailable":
                assert call.arguments() != null;
                getSharedModule().isTorchAvailable(call.arguments(), new FlutterResult(result));
                break;

            case "emitFeedback":
                assert call.arguments() != null;
                getSharedModule().emitFeedback(call.arguments(), new FlutterResult(result));
                break;

            case "viewPointForFramePoint":
                assert call.arguments() != null;
                getSharedModule().viewPointForFramePoint(call.arguments(), new FlutterResult(result));
                break;

            case "viewQuadrilateralForFrameQuadrilateral":
                assert call.arguments() != null;
                getSharedModule().viewQuadrilateralForFrameQuadrilateral(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "switchCameraToDesiredState":
                assert call.arguments() != null;
                getSharedModule().switchCameraToDesiredState(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "addModeToContext":
                assert call.arguments() != null;
                getSharedModule().addModeToContext(call.arguments(), new FlutterResult(result));
                break;

            case "removeModeFromContext":
                assert call.arguments() != null;
                getSharedModule().removeModeFromContext(call.arguments(), new FlutterResult(result));
                break;

            case "removeAllModesFromContext":
                getSharedModule().removeAllModes(new FlutterResult(result));
                break;

            case "updateDataCaptureView":
                assert call.arguments() != null;
                getSharedModule().updateDataCaptureView(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "addOverlay":
                assert call.arguments() != null;
                getSharedModule().addOverlayToView(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "removeOverlay":
                assert call.arguments() != null;
                getSharedModule().removeOverlayFromView(
                        call.arguments(),
                        new FlutterResult(result)
                );
                break;

            case "removeAllOverlays":
                getSharedModule().removeAllOverlays(new FlutterResult(result));
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    private volatile CoreModule sharedModuleInstance;

    private CoreModule getSharedModule() {
        if (sharedModuleInstance == null) {
            synchronized (this) {
                if (sharedModuleInstance == null) {
                    sharedModuleInstance = (CoreModule)this.serviceLocator.resolve(CoreModule.class.getName());
                }
            }
        }
        return sharedModuleInstance;
    }
}
