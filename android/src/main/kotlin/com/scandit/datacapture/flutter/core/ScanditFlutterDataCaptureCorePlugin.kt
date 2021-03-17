/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core

import android.content.Context
import com.scandit.datacapture.flutter.core.ui.FlutterDataCaptureView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

/** ScanditFlutterDataCaptureCorePlugin. */
class ScanditFlutterDataCaptureCorePlugin :
    FlutterPlugin,
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    companion object {
        @Suppress("unused")
        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            val plugin = ScanditFlutterDataCaptureCorePlugin()
            registrar
                .platformViewRegistry()
                .registerViewFactory("com.scandit.DataCaptureView", plugin)

            val channel = MethodChannel(
                registrar.messenger(),
                "com.scandit.datacapture.core.method/datacapture_defaults"
            )

            plugin.scanditFlutterDataCaptureCoreMethodHandler =
                ScanditFlutterDataCaptureCoreMethodHandler(
                    registrar.context(),
                    registrar.messenger()
                )

            channel.setMethodCallHandler(plugin.scanditFlutterDataCaptureCoreMethodHandler)
        }
    }

    private lateinit var methodChannel: MethodChannel

    var scanditFlutterDataCaptureCoreMethodHandler:
        ScanditFlutterDataCaptureCoreMethodHandler? = null

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView =
        FlutterDataCaptureView(context)

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        scanditFlutterDataCaptureCoreMethodHandler =
            ScanditFlutterDataCaptureCoreMethodHandler(
                binding.applicationContext,
                binding.binaryMessenger
            )

        binding.platformViewRegistry.registerViewFactory(
            "com.scandit.DataCaptureView",
            this
        )
        methodChannel = MethodChannel(
            binding.binaryMessenger,
            "com.scandit.datacapture.core.method/datacapture_defaults"
        )
        methodChannel.setMethodCallHandler(scanditFlutterDataCaptureCoreMethodHandler)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)

        dispose()
    }

    private fun dispose() {
        scanditFlutterDataCaptureCoreMethodHandler?.dispose()
    }
}
