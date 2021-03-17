/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.handler

import com.scandit.datacapture.core.ui.DataCaptureView

internal object DataCaptureViewHandler {

    private var viewListener: ViewListener? = null

    internal var dataCaptureView: DataCaptureView? = null
        set(value) {
            field = value

            value?.let {
                viewListener?.onViewDeserialized(it)
            }
        }

    internal fun setViewListener(listener: ViewListener) {
        viewListener = listener
        dataCaptureView?.let {
            listener.onViewDeserialized(it)
        }
    }

    internal interface ViewListener {
        fun onViewDeserialized(view: DataCaptureView)
    }
}
