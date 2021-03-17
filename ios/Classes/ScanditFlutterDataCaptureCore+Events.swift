/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

extension ScanditFlutterDataCaptureCore {
    func send(on sink: BaseEventSink, body: [String: Any]? = nil) -> Bool {
        guard hasListeners else { return false }
        sink.send(body: body)
        return true
    }
}

class BaseEventSink: NSObject, FlutterStreamHandler {
    var sink: FlutterEventSink?

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        return nil
    }

    func send(body: [String: Any]?) {
        let payload = String(data: try! JSONSerialization.data(withJSONObject: body ?? [:], options: []),
                             encoding: .utf8)
        sink?(payload)
    }
}
