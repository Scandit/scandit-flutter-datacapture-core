/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core

import com.scandit.datacapture.flutter.core.extensions.getMethodChannel
import com.scandit.datacapture.flutter.core.utils.FlutterEmitter
import com.scandit.datacapture.frameworks.core.CoreModule
import com.scandit.datacapture.frameworks.core.listeners.FrameworksDataCaptureContextListener
import com.scandit.datacapture.frameworks.core.listeners.FrameworksDataCaptureViewListener
import com.scandit.datacapture.frameworks.core.listeners.FrameworksFrameSourceListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.locks.ReentrantLock
import kotlin.concurrent.withLock

/** ScanditFlutterDataCaptureCorePlugin. */
class ScanditFlutterDataCaptureCorePlugin :
    FlutterPlugin {

    companion object {
        @JvmStatic
        private val lock = ReentrantLock()

        @JvmStatic
        private var isPluginAttached = false

        private const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.core/event_channel"
        private const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.core/method_channel"
        private const val DATACAPTURE_VIEW_ID = "com.scandit.DataCaptureView"
    }

    private var methodChannel: MethodChannel? = null

    private var dataCaptureCoreMethodHandler: DataCaptureCoreMethodHandler? = null

    private var coreModule: CoreModule? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        lock.withLock {
            if (isPluginAttached) return

            val eventEmitter = FlutterEmitter(
                EventChannel(
                    binding.binaryMessenger,
                    EVENT_CHANNEL_NAME
                )
            )

            val coreModule = CoreModule(
                FrameworksFrameSourceListener(
                    eventEmitter
                ),
                FrameworksDataCaptureContextListener(
                    eventEmitter
                ),
                FrameworksDataCaptureViewListener(
                    eventEmitter
                )
            ).also {
                it.onCreate(binding.applicationContext)
                it.registerDataCaptureContextListener()
                it.registerDataCaptureViewListener()
                it.registerFrameSourceListener()
            }

            dataCaptureCoreMethodHandler = DataCaptureCoreMethodHandler(
                coreModule
            )

            this.coreModule = coreModule

            binding.platformViewRegistry.registerViewFactory(
                DATACAPTURE_VIEW_ID,
                ScanditPlatformViewFactory(coreModule)
            )
            methodChannel = binding.getMethodChannel(METHOD_CHANNEL_NAME).also {
                it.setMethodCallHandler(dataCaptureCoreMethodHandler)
            }
            isPluginAttached = true
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        lock.withLock {
            methodChannel?.setMethodCallHandler(null)
            methodChannel = null
            coreModule?.onDestroy()
            coreModule = null
            isPluginAttached = false
        }
    }
}
