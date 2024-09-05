/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.ui;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import com.scandit.datacapture.core.ui.DataCaptureView;
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult;
import com.scandit.datacapture.frameworks.core.CoreModule;

import java.lang.ref.WeakReference;

@SuppressLint("ViewConstructor")
public class FlutterDataCaptureView extends FlutterBasePlatformView {
    private WeakReference<DataCaptureView> currentDataCaptureView = new WeakReference<>(null);
    private final CoreModule coreModule;

    public FlutterDataCaptureView(Context context, CoreModule coreModule, String creationJson) {
        super(context);
        this.coreModule = coreModule;

        DataCaptureView view = coreModule.createDataCaptureView(creationJson, new FlutterLogInsteadOfResult());
        if (view != null) {
            addDataCaptureViewToPlatformView(view, this);
            currentDataCaptureView = new WeakReference<>(view);
        }
    }

    @Override
    public View getView() {
        return this;
    }

    @Override
    public void dispose() {
        super.dispose();
        removeAllViews();
        DataCaptureView view = currentDataCaptureView.get();
        if (view != null) {
            coreModule.dataCaptureViewDisposed(view);
            currentDataCaptureView = new WeakReference<>(null);
        }
    }

    private void addDataCaptureViewToPlatformView(DataCaptureView dataCaptureView, FrameLayout platformView) {
        if (platformView.getChildCount() > 0 && platformView.getChildAt(0) == dataCaptureView) {
            // Same instance already attached. No need to detach and attach it again because it will
            // trigger some overlay cleanup that we don't want.
            return;
        }

        ViewGroup parent = (ViewGroup) dataCaptureView.getParent();
        if (parent != null) {
            parent.removeView(dataCaptureView);
        }
        platformView.addView(dataCaptureView, ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
    }

    @Override
    public void onCurrentTopViewVisibleChanged(String topViewId) {
        if (topViewId != null && topViewId.equals(viewId)) {
            dispatchWindowVisibilityChanged(getVisibility());
        }
    }
}
