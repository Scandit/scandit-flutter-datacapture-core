/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.scandit.datacapture.flutter.core.utils.DefaultActivityLifecycleObserver;
import com.scandit.datacapture.frameworks.core.FrameworkModule;
import com.scandit.datacapture.frameworks.core.locator.DefaultServiceLocator;
import com.scandit.datacapture.frameworks.core.locator.ServiceLocator;
import com.scandit.datacapture.frameworks.core.utils.DefaultFrameworksLog;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.concurrent.locks.ReentrantLock;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference;
import io.flutter.plugin.common.MethodChannel;

public abstract class BaseFlutterPlugin implements FlutterPlugin {
    private final ServiceLocator<FrameworkModule> serviceLocator = DefaultServiceLocator.getInstance();

    private static final ReentrantLock lock = new ReentrantLock();

    private WeakReference<FlutterPluginBinding> binding = new WeakReference<>(null);

    private final ArrayList<MethodChannel> channels = new ArrayList<>();

    private final ArrayList<String> modules = new ArrayList<>();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        lock.lock();
        try {
            this.binding = new WeakReference<>(binding);
            if (getActivePluginInstanceCount() == 1) {
                setupModules(binding);
            }
            setupMethodChannels(binding, serviceLocator);
            setupPlatformViewRegistry(binding, serviceLocator);
        } finally {
            lock.unlock();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        lock.lock();
        try {
            this.binding = new WeakReference<>(null);
            disposeMethodChannels();
            if (getActivePluginInstanceCount() == 0) {
                disposeRegisteredModules();
            }
        } finally {
            lock.unlock();
        }
    }

    protected abstract int getActivePluginInstanceCount();

    protected abstract void setupModules(FlutterPluginBinding binding);

    protected abstract void setupMethodChannels(FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator);

    protected void setupPlatformViewRegistry(FlutterPluginBinding binding, ServiceLocator<FrameworkModule> serviceLocator) {
        // Platforms can override this function to register all the views to the registry
    }

    @Nullable
    protected FlutterPluginBinding getCurrentBinding() {
        return binding.get();
    }

    protected void registerChannel(MethodChannel channel) {
        channels.add(channel);
    }

    protected void registerModule(FrameworkModule module) {
        serviceLocator.register(module);
        modules.add(module.getClass().getName());
    }

    protected <T extends FrameworkModule> T resolveModule(Class<T> type) {
        return type.cast(serviceLocator.resolve(type.getName()));
    }

    protected void removeModuleByName(String moduleName) {
        FrameworkModule module = serviceLocator.remove(moduleName);
        if (module != null) {
            module.onDestroy();
        }
    }

    @NonNull
    protected MethodChannel createChannel(FlutterPluginBinding binding, String channelName) {
        return new MethodChannel(binding.getBinaryMessenger(), channelName);
    }

    protected void attachLifecycleObserver(@Nullable ActivityPluginBinding binding) {
        if (binding == null) return;
        if (binding.getLifecycle() instanceof HiddenLifecycleReference) {
            HiddenLifecycleReference lifecycleReference = (HiddenLifecycleReference) binding.getLifecycle();
            lifecycleReference.getLifecycle().addObserver(DefaultActivityLifecycleObserver.getInstance());
        } else {
            DefaultFrameworksLog.getInstance().error("ActivityPluginBinding lifecycle is not of the expected type. " +
                    String.format("Current instance %s, but HiddenLifecycleReference was expected", binding.getLifecycle().getClass().getSimpleName()));
        }
    }

    protected void detachLifecycleObserver(@Nullable ActivityPluginBinding binding) {
        if (binding == null) return;
        if (binding.getLifecycle() instanceof HiddenLifecycleReference) {
            HiddenLifecycleReference lifecycleReference = (HiddenLifecycleReference) binding.getLifecycle();
            lifecycleReference.getLifecycle().removeObserver(DefaultActivityLifecycleObserver.getInstance());
        }
    }

    private void disposeMethodChannels() {
        for (MethodChannel channel : channels) {
            channel.setMethodCallHandler(null);
        }
        channels.clear();
    }

    private void disposeRegisteredModules() {
        for (String moduleName : modules) {
            removeModuleByName(moduleName);
        }
    }
}
