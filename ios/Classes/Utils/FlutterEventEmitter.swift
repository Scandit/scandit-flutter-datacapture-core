/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksCore

public class FlutterEventEmitter: NSObject, Emitter, FlutterStreamHandler {
    private let eventChannel: FlutterEventChannel
    private var eventSink: FlutterEventSink?

    public init(eventChannel: FlutterEventChannel, autoEnableListener: Bool = true) {
        self.eventChannel = eventChannel
        super.init()
        if autoEnableListener {
            enableListener()
        }
    }

    public func emit(name: String, payload: [String: Any?]) {
        guard let sink = eventSink else { return }
        var payload = payload
        payload["event"] = name
        let jsonString = String(data: try! JSONSerialization.data(withJSONObject: payload),
                                encoding: .utf8)!
        dispatchMainSync {
            sink(jsonString)
        }
    }

    public func onListen(withArguments arguments: Any?,
                         eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    public func enableListener() {
        eventChannel.setStreamHandler(self)
    }

    public func disableListener() {
        eventChannel.setStreamHandler(nil)
    }

    public func hasListener(for event: String) -> Bool {
        true
    }
}
