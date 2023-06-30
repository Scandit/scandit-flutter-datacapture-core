/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.ui

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.view.ViewGroup
import android.view.ViewGroup.LayoutParams.MATCH_PARENT
import android.widget.FrameLayout
import com.scandit.datacapture.core.ui.DataCaptureView
import com.scandit.datacapture.frameworks.core.CoreModule
import com.scandit.datacapture.frameworks.core.deserialization.DeserializationLifecycleObserver
import io.flutter.plugin.platform.PlatformView

@SuppressLint("ViewConstructor")
class FlutterDataCaptureView(
    context: Context,
    private val coreModule: CoreModule
) : FrameLayout(context), PlatformView, DeserializationLifecycleObserver.Observer {

    init {
        DeserializationLifecycleObserver.attach(this)
        platformViewCreated(this)
    }

    override fun getView(): View = this

    override fun onDataCaptureViewDeserialized(dataCaptureView: DataCaptureView) {
        addDataCaptureViewToPlatformView(dataCaptureView, this)
    }

    override fun dispose() {
        platformViewDisposed()
    }

    private fun platformViewCreated(platformView: FrameLayout) {
        createdPlatformViews.add(platformView)
        val dcView = coreModule.dataCaptureView ?: return
        addDataCaptureViewToPlatformView(dcView, platformView)
    }

    private fun platformViewDisposed() {
        removeAllViews()
        createdPlatformViews.remove(this)
        if (createdPlatformViews.isEmpty()) {
            coreModule.disposeDataCaptureView()
        }
        val dcView = coreModule.dataCaptureView ?: return
        val previousContainer = createdPlatformViews.lastOrNull()
        previousContainer?.let {
            addDataCaptureViewToPlatformView(dcView, it)
        }
    }

    private fun addDataCaptureViewToPlatformView(
        dataCaptureView: DataCaptureView,
        platformView: FrameLayout
    ) {
        dataCaptureView.parent?.let {
            (it as ViewGroup).removeView(dataCaptureView)
        }
        platformView.addView(dataCaptureView, MATCH_PARENT, MATCH_PARENT)
    }

    companion object {
        private val createdPlatformViews = mutableListOf<FrameLayout>()
    }
}
