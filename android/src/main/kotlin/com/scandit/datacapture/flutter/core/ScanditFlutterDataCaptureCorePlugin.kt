/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
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
    }

    private lateinit var methodChannel: MethodChannel

    var scanditFlutterDataCaptureCoreMethodHandler:
        ScanditFlutterDataCaptureCoreMethodHandler? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        lock.withLock {
            if (isPluginAttached) return

            scanditFlutterDataCaptureCoreMethodHandler =
                ScanditFlutterDataCaptureCoreMethodHandler(
                    binding.applicationContext,
                    binding.binaryMessenger
                )

            binding.platformViewRegistry.registerViewFactory(
                "com.scandit.DataCaptureView",
                ScanditPlatformViewFactory()
            )
            methodChannel = MethodChannel(
                binding.binaryMessenger,
                "com.scandit.datacapture.core.method/datacapture_defaults"
            )
            methodChannel.setMethodCallHandler(scanditFlutterDataCaptureCoreMethodHandler)
            isPluginAttached = true
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        lock.withLock {
            methodChannel.setMethodCallHandler(null)
            dispose()
            isPluginAttached = false
        }
    }

    private fun dispose() {
        scanditFlutterDataCaptureCoreMethodHandler?.dispose()
    }
}
