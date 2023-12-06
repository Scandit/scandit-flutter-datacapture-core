/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.ui

import android.content.Context
import android.view.View
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.widget.FrameLayout
import com.scandit.datacapture.core.ui.DataCaptureView
import com.scandit.datacapture.flutter.core.handler.DataCaptureViewHandler
import io.flutter.plugin.platform.PlatformView

class FlutterDataCaptureView(
    context: Context
) : FrameLayout(context), PlatformView, DataCaptureViewHandler.ViewListener {

    init {
        DataCaptureViewHandler.dataCaptureView?.let { view ->
            addView(view, MATCH_PARENT, MATCH_PARENT)
        }
    }

    override fun getView(): View = this

    override fun dispose() {
        removeAllViews()
    }

    override fun onViewDeserialized(view: DataCaptureView) {
        addView(view, MATCH_PARENT, MATCH_PARENT)
    }
}
