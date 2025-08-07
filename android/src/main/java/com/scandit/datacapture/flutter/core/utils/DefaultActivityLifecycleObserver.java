/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;

import com.scandit.datacapture.frameworks.core.lifecycle.ActivityLifecycleDispatcher;
import com.scandit.datacapture.frameworks.core.lifecycle.DefaultActivityLifecycle;

public class DefaultActivityLifecycleObserver implements DefaultLifecycleObserver {
    private static volatile DefaultActivityLifecycleObserver instance;

    final ActivityLifecycleDispatcher dispatcher;

    private DefaultActivityLifecycleObserver(ActivityLifecycleDispatcher dispatcher) {
        this.dispatcher = dispatcher;
    }

    public static DefaultActivityLifecycleObserver getInstance() {
        if (instance == null) {
            synchronized (DefaultActivityLifecycleObserver.class) {
                if (instance == null) {
                    instance = new DefaultActivityLifecycleObserver(
                            DefaultActivityLifecycle.Companion.getInstance()
                    );
                }
            }
        }
        return instance;
    }

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        dispatcher.dispatchOnCreate();
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        dispatcher.dispatchOnDestroy();
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        dispatcher.dispatchOnPause();
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        dispatcher.dispatchOnResume();
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        dispatcher.dispatchOnStart();
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        dispatcher.dispatchOnStop();
    }
}
