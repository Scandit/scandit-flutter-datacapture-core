/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.ui

import android.content.Context
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView
import java.util.UUID

abstract class FlutterBasePlatformView(context: Context) : FrameLayout(context), PlatformView {

    protected val viewId = UUID.randomUUID().toString()

    init {
        initAfterConstruction()
    }

    private fun initAfterConstruction() {
        onNewViewAdded(this)
    }

    override fun dispose() {
        onViewDisposed(this)
    }

    abstract fun onCurrentTopViewVisibleChanged(topViewId: String?)

    private fun onNewViewAdded(view: FlutterBasePlatformView) {
        synchronized(platformViews) {
            platformViews.add(view)
        }
    }

    private fun onViewDisposed(view: FlutterBasePlatformView) {
        synchronized(platformViews) {
            platformViews.remove(view)
            val topViewId = platformViews.lastOrNull()?.viewId
            for (listener in platformViews) {
                // Our native SDK doesn't support rendering the camera frames to multiple
                // DataCaptureViews at the same time (optimized). Since flutter platform views
                // are not hidden or closed when a new one is opened, the newly opened platform
                // view will "steal" the rendering from the previous screen. Closing this screen
                // and going back to the previous visible platform view doesn't trigger
                // anything, so the previous platform view is not able to resume rendering
                // the camera frames, unless we dispatchWindowVisibilityChanged(VISIBLE) in the
                // view to make the current platform view the one who streams the camera frames.
                listener.onCurrentTopViewVisibleChanged(topViewId)
            }
        }
    }

    companion object {
        private val platformViews = java.util.Collections.synchronizedList(
            mutableListOf<FlutterBasePlatformView>()
        )
    }
}
