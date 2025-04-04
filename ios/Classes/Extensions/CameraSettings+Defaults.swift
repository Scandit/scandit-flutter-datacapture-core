/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditCaptureCore

extension CameraSettings {
    public var defaults: [String: Any] {
        return [
            "preferredResolution": preferredResolution.jsonString,
            "zoomFactor": zoomFactor,
            "focusRange": focusRange.jsonString,
            "shouldPreferSmoothAutoFocus": shouldPreferSmoothAutoFocus,
            "focusGestureStrategy": focusGestureStrategy.jsonString,
            "zoomGestureZoomFactor": zoomGestureZoomFactor
        ]
    }
}
