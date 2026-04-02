/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.scandit.datacapture.flutter.core.ui.ScanditPlatformViewFactory;
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter;
import com.scandit.datacapture.frameworks.core.CoreModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;

import java.lang.ref.WeakReference;
import java.util.concurrent.atomic.AtomicInteger;

public class ScanditFlutterDataCaptureCorePlugin extends BaseFlutterPlugin implements FlutterPlugin, ActivityAware {

    private final static FlutterEmitter coreEmitter = new FlutterEmitter(DataCaptureCoreMethodHandler.EVENT_CHANNEL_NAME);

    private WeakReference<ActivityPluginBinding> activityBinding = new WeakReference<>(null);

    private static final AtomicInteger activePluginInstances = new AtomicInteger(0);

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.incrementAndGet();
        super.onAttachedToEngine(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activePluginInstances.decrementAndGet();
        super.onDetachedFromEngine(binding);
    }

    @Override
    protected int getActivePluginInstanceCount() {
        return activePluginInstances.get();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        setupEventChannels();
        activityBinding = new WeakReference<>(binding);
        attachLifecycleObserver(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        disposeEventChannels();
        detachLifecycleObserver(activityBinding.get());
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        disposeEventChannels();
        detachLifecycleObserver(activityBinding.get());
    }

    @Override
    protected void setupModules(FlutterPlugin.FlutterPluginBinding binding) {
        CoreModule coreModule = resolveModule(CoreModule.class);
        if (coreModule != null) return;

        coreModule = CoreModule.create(coreEmitter);
        coreModule.onCreate(binding.getApplicationContext());
        coreModule.registerDataCaptureContextListener();
        coreModule.registerFrameSourceListener();

        registerModule(coreModule);
    }

    @Override
    protected void setupMethodChannels(@NonNull FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator) {
        DataCaptureCoreMethodHandler dataCaptureCoreMethodHandler = new DataCaptureCoreMethodHandler(serviceLocator);
        MethodChannel methodChannel = createChannel(binding, DataCaptureCoreMethodHandler.METHOD_CHANNEL_NAME);
        methodChannel.setMethodCallHandler(dataCaptureCoreMethodHandler);
        registerChannel(methodChannel);
    }

    @Override
    protected void setupPlatformViewRegistry(FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator) {
        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.DataCaptureView",
                new ScanditPlatformViewFactory(serviceLocator)
        );
    }

    private void setupEventChannels() {
        FlutterPluginBinding binding = getCurrentBinding();
        if (binding != null) {
            coreEmitter.addChannel(binding.getBinaryMessenger());
        }
    }

    private void disposeEventChannels() {
        FlutterPluginBinding binding = getCurrentBinding();
        if (binding != null) {
            coreEmitter.removeChannel(binding.getBinaryMessenger());
        }
    }

    @VisibleForTesting
    public static void resetActiveInstances() {
        activePluginInstances.set(0);
    }
}
