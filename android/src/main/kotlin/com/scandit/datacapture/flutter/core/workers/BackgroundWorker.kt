/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.workers

import android.os.Handler
import android.os.HandlerThread

class BackgroundWorker(
    workerName: String
) : Worker() {

    override val handler: Handler

    init {
        HandlerThread(workerName).also { handlerThread ->
            handlerThread.start()
            handler = Handler(handlerThread.looper)
        }
    }
}
