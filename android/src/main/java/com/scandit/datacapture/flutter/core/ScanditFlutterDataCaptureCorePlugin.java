/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core;

import androidx.annotation.NonNull;

import com.scandit.datacapture.flutter.core.extensions.MethodChannelExtensions;
import com.scandit.datacapture.flutter.core.ui.ScanditPlatformViewFactory;
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter;
import com.scandit.datacapture.flutter.core.utils.DefaultActivityLifecycleObserver;
import com.scandit.datacapture.frameworks.core.CoreModule;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.listeners.FrameworksDataCaptureContextListener;
import com.scandit.datacapture.frameworks.core.listeners.FrameworksDataCaptureViewListener;
import com.scandit.datacapture.frameworks.core.listeners.FrameworksFrameSourceListener;
import com.scandit.datacapture.frameworks.core.locator.DefaultServiceLocator;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.core.utils.DefaultFrameworksLog;
import com.scandit.datacapture.frameworks.core.utils.FrameworksLog;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
import io.flutter.plugin.common.MethodChannel;

import java.lang.ref.WeakReference;
import java.util.concurrent.locks.ReentrantLock;

public class ScanditFlutterDataCaptureCorePlugin implements FlutterPlugin, ActivityAware {

    private static final ReentrantLock lock = new ReentrantLock();

    private final static FlutterEmitter coreEmitter = new FlutterEmitter(DataCaptureCoreMethodHandler.EVENT_CHANNEL_NAME);

    private final ServiceLocator<FrameworkModule> serviceLocator = DefaultServiceLocator.getInstance();

    private MethodChannel methodChannel;
    private WeakReference<FlutterPlugin.FlutterPluginBinding> flutterPluginBinding = new WeakReference<>(null);

    private WeakReference<ActivityPluginBinding> activityBinding = new WeakReference<>(null);

    private final FrameworksLog logger = DefaultFrameworksLog.getInstance();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        flutterPluginBinding = new WeakReference<>(binding);
        setupModules(binding);
        setupMethodChannels(binding);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPlugin.FlutterPluginBinding binding) {
        flutterPluginBinding = new WeakReference<>(null);
        disposeModules();
        disposeMethodChannels();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        setupEventChannels();
        activityBinding = new WeakReference<>(binding);

        if (binding.getLifecycle() instanceof HiddenLifecycleReference) {
            HiddenLifecycleReference lifecycleReference = (HiddenLifecycleReference) binding.getLifecycle();
            lifecycleReference.getLifecycle().addObserver(DefaultActivityLifecycleObserver.getInstance());
        } else {
            logger.error("ActivityPluginBinding lifecycle is not of the expected type. " +
                    String.format("Current instance %s, but HiddenLifecycleReference was expected", binding.getLifecycle().getClass().getSimpleName()));
        }
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        disposeEventChannels();
        ActivityPluginBinding binding = activityBinding.get();
        if (binding == null) return;
        if (binding.getLifecycle() instanceof HiddenLifecycleReference) {
            HiddenLifecycleReference lifecycleReference = (HiddenLifecycleReference) binding.getLifecycle();
            lifecycleReference.getLifecycle().removeObserver(DefaultActivityLifecycleObserver.getInstance());
        }
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        disposeEventChannels();
        ActivityPluginBinding binding = activityBinding.get();
        if (binding == null) return;
        if (binding.getLifecycle() instanceof HiddenLifecycleReference) {
            HiddenLifecycleReference lifecycleReference = (HiddenLifecycleReference) binding.getLifecycle();
            lifecycleReference.getLifecycle().removeObserver(DefaultActivityLifecycleObserver.getInstance());
        }
    }

    private void setupEventChannels() {
        FlutterPluginBinding binding = flutterPluginBinding.get();
        if (binding != null) {
            coreEmitter.addChannel(binding.getBinaryMessenger());
        }
    }

    private void disposeEventChannels() {
        FlutterPluginBinding binding = flutterPluginBinding.get();
        if (binding != null) {
            coreEmitter.removeChannel(binding.getBinaryMessenger());
        }
    }

    private void setupModules(FlutterPlugin.FlutterPluginBinding binding) {
        lock.lock();
        try {
            CoreModule coreModule = (CoreModule) serviceLocator.resolve(CoreModule.class.getName());
            if (coreModule != null) return;

            coreModule = CoreModule.create(
                    new FrameworksFrameSourceListener(coreEmitter),
                    new FrameworksDataCaptureContextListener(coreEmitter),
                    new FrameworksDataCaptureViewListener(coreEmitter)
            );
            coreModule.onCreate(binding.getApplicationContext());
            coreModule.registerDataCaptureContextListener();
            coreModule.registerDataCaptureViewListener();
            coreModule.registerFrameSourceListener();

            serviceLocator.register(coreModule);
        } finally {
            lock.unlock();
        }
    }

    private void disposeModules() {
        lock.lock();
        try {
            FrameworkModule module = serviceLocator.remove(CoreModule.class.getName());
            if (module != null) {
                module.onDestroy();
            }
        } finally {
            lock.unlock();
        }
    }

    private void setupMethodChannels(@NonNull FlutterPluginBinding binding) {
        DataCaptureCoreMethodHandler dataCaptureCoreMethodHandler = new DataCaptureCoreMethodHandler(serviceLocator);
        binding.getPlatformViewRegistry().registerViewFactory(
                "com.scandit.DataCaptureView",
                new ScanditPlatformViewFactory(serviceLocator)
        );
        methodChannel = MethodChannelExtensions.getMethodChannel(binding, DataCaptureCoreMethodHandler.METHOD_CHANNEL_NAME);
        methodChannel.setMethodCallHandler(dataCaptureCoreMethodHandler);
    }

    private void disposeMethodChannels() {
        if (methodChannel != null) {
            methodChannel.setMethodCallHandler(null);
            methodChannel = null;
        }
    }
}
