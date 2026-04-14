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

        do {
            // Serialize payload to JSON string
            let payloadData = try JSONSerialization.data(withJSONObject: payload)
            guard let payloadString = String(data: payloadData, encoding: .utf8) else {
                return
            }

            // Create wrapper Dictionary with event name, payload JSON string,
            // and optional modeId/viewId for efficient filtering
            var wrapper: [String: Any] = [
                "event": name,
                "payload": payloadString,
            ]

            // Include modeId and viewId at root level if present in payload
            // This allows Dart to filter events without decoding the payload JSON
            if let modeId = payload["modeId"] {
                wrapper["modeId"] = modeId
            }
            if let viewId = payload["viewId"] {
                wrapper["viewId"] = viewId
            }

            dispatchMain {
                sink(wrapper)
            }
        } catch {
            // Silently fail - event emission is non-critical
            return
        }
    }

    public func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
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

    public func hasViewSpecificListenersForEvent(_ viewId: Int, for event: String) -> Bool {
        true
    }

    public func hasModeSpecificListenersForEvent(_ viewId: Int, for event: String) -> Bool {
        true
    }
}
