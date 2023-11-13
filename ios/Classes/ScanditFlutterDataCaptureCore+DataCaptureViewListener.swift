/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditCaptureCore

extension ScanditFlutterDataCaptureCore: DataCaptureViewListener {
    public func dataCaptureView(_ view: DataCaptureView,
                                didChange size: CGSize,
                                orientation: UIInterfaceOrientation) {
        guard send(on: coreEventSink, body: [
            "size": [
                "width": size.width,
                "height": size.height
            ],
            "orientation": orientation.jsonString,
            "event": "DataCaptureViewListener.onSizeChanged",
        ]) else { return }
    }
}
