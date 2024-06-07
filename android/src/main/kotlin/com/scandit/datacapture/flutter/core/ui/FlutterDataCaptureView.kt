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
import com.scandit.datacapture.flutter.core.utils.FlutterLogInsteadOfResult
import com.scandit.datacapture.frameworks.core.CoreModule
import java.lang.ref.WeakReference

@SuppressLint("ViewConstructor")
class FlutterDataCaptureView(
    context: Context,
    private val coreModule: CoreModule,
    creationJson: String
) : FlutterBasePlatformView(context) {

    private var currentDataCaptureView: WeakReference<DataCaptureView?> = WeakReference(null)

    init {
        val view = coreModule.createDataCaptureView(
            creationJson,
            FlutterLogInsteadOfResult()
        )
        if (view != null) {
            addDataCaptureViewToPlatformView(view, this)
            currentDataCaptureView = WeakReference(view)
        }
    }

    override fun getView(): View = this

    override fun dispose() {
        super.dispose()
        removeAllViews()
        currentDataCaptureView.get()?.let {
            coreModule.dataCaptureViewDisposed(it)
            currentDataCaptureView = WeakReference(null)
        }
    }

    private fun addDataCaptureViewToPlatformView(
        dataCaptureView: DataCaptureView,
        platformView: FrameLayout
    ) {
        if (platformView.childCount > 0 && platformView.getChildAt(0) === dataCaptureView) {
            // Same instance already attached. No need to detach and attach it again because it will
            // trigger some overlay cleanup that we don't want.
            return
        }

        dataCaptureView.parent?.let {
            (it as ViewGroup).removeView(dataCaptureView)
        }
        platformView.addView(dataCaptureView, MATCH_PARENT, MATCH_PARENT)
    }

    override fun onCurrentTopViewVisibleChanged(topViewId: String?) {
        if (topViewId == viewId) {
            dispatchWindowVisibilityChanged(visibility)
        }
    }
}
