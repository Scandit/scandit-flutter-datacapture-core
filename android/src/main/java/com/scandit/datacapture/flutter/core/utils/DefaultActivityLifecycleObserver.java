/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.LifecycleOwner;

import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class DefaultActivityLifecycleObserver implements DefaultLifecycleObserver {
    private static volatile DefaultActivityLifecycleObserver instance;

    private final List<ViewObserver> observers = new CopyOnWriteArrayList<>();

    private DefaultActivityLifecycleObserver() {
    }

    public static DefaultActivityLifecycleObserver getInstance() {
        if (instance == null) {
            synchronized (DefaultActivityLifecycleObserver.class) {
                if (instance == null) {
                    instance = new DefaultActivityLifecycleObserver();
                }
            }
        }
        return instance;
    }

    public void addObserver(ViewObserver observer) {
        observers.add(observer);
    }

    public void removeObserver(ViewObserver observer) {
        observers.remove(observer);
    }

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        for (ViewObserver observer : observers) {
            observer.onCreate();
        }
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        for (ViewObserver observer : observers) {
            observer.onDestroy();
        }
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        for (ViewObserver observer : observers) {
            observer.onPause();
        }
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        for (ViewObserver observer : observers) {
            observer.onResume();
        }
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        for (ViewObserver observer : observers) {
            observer.onStart();
        }
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        for (ViewObserver observer : observers) {
            observer.onStop();
        }
    }

    public interface ViewObserver {
        void onCreate();

        void onStart();

        void onResume();

        void onPause();

        void onStop();

        void onDestroy();
    }
}
