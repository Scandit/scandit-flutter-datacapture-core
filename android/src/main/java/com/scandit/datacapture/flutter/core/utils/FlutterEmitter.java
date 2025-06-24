/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */
package com.scandit.datacapture.flutter.core.utils;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.scandit.datacapture.frameworks.core.events.Emitter;
import com.scandit.datacapture.frameworks.core.utils.DefaultMainThread;
import com.scandit.datacapture.frameworks.core.utils.MainThread;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;

import org.json.JSONObject;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicReference;

public class FlutterEmitter implements Emitter {
    private final String channelName;
    private final MainThread mainThread;

    @VisibleForTesting
    final CopyOnWriteArrayList<EventChannel.EventSink> sinkEvents = new CopyOnWriteArrayList<>();
    @VisibleForTesting
    final ConcurrentHashMap<Integer, EventChannel> channels = new ConcurrentHashMap<>();

    public FlutterEmitter(String channelName, MainThread mainThread) {
        this.channelName = channelName;
        this.mainThread = mainThread == null ? DefaultMainThread.getInstance() : mainThread;
    }

    public FlutterEmitter(String channelName) {
        this(channelName, DefaultMainThread.getInstance());
    }

    public void addChannel(BinaryMessenger messenger) {
        EventChannel channel = new EventChannel(messenger, channelName);
        channel.setStreamHandler(new EventChannel.StreamHandler() {
            final AtomicReference<EventChannel.EventSink> event = new AtomicReference<>(null);

            @Override
            public void onCancel(Object arguments) {
                EventChannel.EventSink current = event.get();

                if (current != null) {
                    sinkEvents.remove(current);
                    event.set(null);
                }
            }

            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                this.event.set(events);
                sinkEvents.add(events);
            }
        });
        channels.put(messenger.hashCode(), channel);
    }

    public void removeChannel(BinaryMessenger messenger) {
        EventChannel channel = channels.remove(messenger.hashCode());
        if (channel != null) {
            channel.setStreamHandler(null);
        }
    }

    @Override
    public void emit(@NonNull String eventName, java.util.Map<String, Object> payload) {
        payload.put(FIELD_EVENT_NAME, eventName);
        for (EventChannel.EventSink event : this.sinkEvents) {
            mainThread.runOnMainThread(() -> event.success(new JSONObject(payload).toString()));
        }
    }

    private static final String FIELD_EVENT_NAME = "event";

    @Override
    public boolean hasListenersForEvent(@NonNull String s) {
        return true;
    }
}
