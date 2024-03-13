/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils

import com.scandit.datacapture.frameworks.core.events.Emitter
import com.scandit.datacapture.frameworks.core.utils.DefaultMainThread
import com.scandit.datacapture.frameworks.core.utils.MainThread
import io.flutter.plugin.common.EventChannel
import org.json.JSONObject
import java.util.concurrent.atomic.AtomicReference

class FlutterEmitter(
    private val channel: EventChannel,
    autoEnableListener: Boolean = true,
    private val mainThread: MainThread = DefaultMainThread.getInstance()
) :
    EventChannel.StreamHandler, Emitter {

    private var atomicEventSink: AtomicReference<EventChannel.EventSink?> = AtomicReference(null)

    init {
        if (autoEnableListener) enableListener()
    }

    override fun emit(eventName: String, payload: MutableMap<String, Any?>) {
        payload[FIELD_EVENT_NAME] = eventName
        atomicEventSink.get()?.let {
            mainThread.runOnMainThread {
                it.success(JSONObject(payload).toString())
            }
        }
    }

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

    companion object {
        internal const val FIELD_EVENT_NAME = "event"
    }
}
