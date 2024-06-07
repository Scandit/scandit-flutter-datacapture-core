package com.scandit.datacapture.flutter.core;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.core.ui.FlutterDataCaptureView;
import com.scandit.datacapture.frameworks.core.CoreModule;

import java.util.HashMap;

import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class ScanditPlatformViewFactory extends PlatformViewFactory {
    private final CoreModule coreModule;

    public ScanditPlatformViewFactory(CoreModule coreModule) {
        super(StandardMessageCodec.INSTANCE);
        this.coreModule = coreModule;
    }

    @NonNull
    @Override
    public PlatformView create(Context context, int viewId, @Nullable Object args) {
        HashMap<?, ?>  creationArgs = (HashMap<?, ?>) args;

        if (creationArgs == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeCountView without the json.");
        }

        Object creationJson = creationArgs.get("DataCaptureView");

        if (creationJson == null) {
            throw new IllegalArgumentException("Unable to create the BarcodeCountView without the json.");
        }

        return new FlutterDataCaptureView(context, this.coreModule, creationJson.toString());
    }
}
