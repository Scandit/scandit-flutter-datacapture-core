/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.ui;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.frameworks.core.CoreModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class ScanditPlatformViewFactory extends PlatformViewFactory {
    private final ServiceLocator<FrameworkModule> serviceLocator;

    public ScanditPlatformViewFactory(ServiceLocator<FrameworkModule> serviceLocator) {
        super(StandardMessageCodec.INSTANCE);
        this.serviceLocator = serviceLocator;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        HashMap<?, ?>  creationArgs = (HashMap<?, ?>) args;

        if (creationArgs == null) {
            throw new IllegalArgumentException("Unable to create the DataCaptureView without the json.");
        }

        Object creationJson = creationArgs.get("DataCaptureView");

        if (creationJson == null) {
            throw new IllegalArgumentException("Unable to create the DataCaptureView without the json.");
        }

        CoreModule coreModule = (CoreModule) this.serviceLocator.resolve(CoreModule.class.getName());
        if (coreModule == null) {
            throw new IllegalArgumentException("Unable to create the DataCaptureView. Core module not initialized.");
        }

        return new FlutterDataCaptureView(context, coreModule, creationJson.toString());
    }
}
