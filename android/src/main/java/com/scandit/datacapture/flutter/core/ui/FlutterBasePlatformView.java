/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.ui;

import android.content.Context;
import android.widget.FrameLayout;
import io.flutter.plugin.platform.PlatformView;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

public abstract class FlutterBasePlatformView extends FrameLayout implements PlatformView {

    protected final String viewId = UUID.randomUUID().toString();

    public FlutterBasePlatformView(Context context) {
        super(context);
        initAfterConstruction();
    }

    private void initAfterConstruction() {
        onNewViewAdded(this);
    }

    @Override
    public void dispose() {
        onViewDisposed(this);
    }

    public abstract void onCurrentTopViewVisibleChanged(String topViewId);

    private void onNewViewAdded(FlutterBasePlatformView view) {
        synchronized (platformViews) {
            platformViews.add(view);
        }
    }

    private void onViewDisposed(FlutterBasePlatformView view) {
        synchronized (platformViews) {
            platformViews.remove(view);
            String topViewId = platformViews.isEmpty() ? null : platformViews.get(platformViews.size() - 1).viewId;
            for (FlutterBasePlatformView listener : platformViews) {
                // Our native SDK doesn't support rendering the camera frames to multiple
                // DataCaptureViews at the same time (optimized). Since flutter platform views
                // are not hidden or closed when a new one is opened, the newly opened platform
                // view will "steal" the rendering from the previous screen. Closing this screen
                // and going back to the previous visible platform view doesn't trigger
                // anything, so the previous platform view is not able to resume rendering
                // the camera frames, unless we dispatchWindowVisibilityChanged(VISIBLE) in the
                // view to make the current platform view the one who streams the camera frames.
                listener.onCurrentTopViewVisibleChanged(topViewId);
            }
        }
    }

    private static final List<FlutterBasePlatformView> platformViews = Collections.synchronizedList(
        new java.util.ArrayList<>()
    );
}

