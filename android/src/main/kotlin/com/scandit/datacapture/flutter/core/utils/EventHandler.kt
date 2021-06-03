/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils

import io.flutter.plugin.common.EventChannel
import java.util.concurrent.atomic.AtomicReference
import org.json.JSONObject

class EventHandler(private val channel: EventChannel, autoEnableListener: Boolean = true) :
    EventChannel.StreamHandler {

    private var atomicEventSink: AtomicReference<EventChannel.EventSink?> = AtomicReference(null)

    init {
        if (autoEnableListener) enableListener()
    }

    fun send(data: JSONObject) {
        atomicEventSink.get()?.let {
            MainThreadUtil.runOnMainThread {
                it.success(data.toString())
            }
        }
    }

    fun getCurrentEventSink(): EventChannel.EventSink? =
        atomicEventSink.get()

    fun enableListener() {
        channel.setStreamHandler(this)
    }

    fun disableListener() {
        channel.setStreamHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        atomicEventSink.set(events)
    }

    override fun onCancel(arguments: Any?) {
        atomicEventSink.set(null)
    }
}
