/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import ScanditCaptureCore

extension ScanditFlutterDataCaptureCore {
    var defaults: [String: Any?] {
        return [
            "Camera": cameraDefaults,
            "DataCaptureView": dataCaptureViewDefaults,
            "Version": DataCaptureVersion.version(),
            "LaserlineViewfinder": laserlineViewfinderDefaults,
            "RectangularViewfinder": rectangularViewfinderDefaults,
            "Brush": brushDefaults,
            "DeviceId": DataCaptureContext.deviceID,
            "AimerViewfinder": aimerViewfinderDefaults
        ]
    }

    var cameraDefaults: [String: Any?] {
        return [
            "Settings": CameraSettings().defaults,
            "defaultPosition": Camera.default?.position.jsonString,
            "availablePositions": availableCameraPositions
        ]
    }

    var availableCameraPositions: [String] {
        return [CameraPosition.userFacing,
                CameraPosition.worldFacing,
                CameraPosition.unspecified]
            .compactMap { Camera(position: $0) }
            .map { $0.position.jsonString }
    }

    var dataCaptureViewDefaults: [String: Any] {
        var view: DataCaptureView!
        DispatchQueue.main.sync {
            view = DataCaptureView(frame: .zero)
        }
        return [
            "scanAreaMargins": DataCaptureView.defaultScanAreaMargins.jsonString,
            "pointOfInterest": DataCaptureView.defaultPointOfInterest.jsonString,
            "logoAnchor": DataCaptureView.defaultLogoAnchor.jsonString,
            "logoOffset": DataCaptureView.defaultLogoOffset.jsonString,
            "focusGesture": view.focusGesture?.jsonString as Any,
            "zoomGesture": view.zoomGesture?.jsonString as Any
        ]
    }

    var laserlineViewfinderDefaults: [String: Any] {
        let viewfinder = LaserlineViewfinder()
        return [
            "width": viewfinder.width.jsonString,
            "enabledColor": viewfinder.enabledColor.sdcHexString,
            "disabledColor": viewfinder.disabledColor.sdcHexString
        ]
    }

    var rectangularViewfinderDefaults: [String: Any] {
        let rectangularViewfinder = RectangularViewfinder()
        return [
            "size": rectangularViewfinder.sizeWithUnitAndAspect.jsonString,
            "color": rectangularViewfinder.color.sdcHexString
        ]
    }

    var brushDefaults: [String: Any] {
        let brush = Brush()
        return [
            "fillColor": brush.fillColor.sdcHexString,
            "strokeColor": brush.strokeColor.sdcHexString,
            "strokeWidth": brush.strokeWidth
        ]
    }

    var aimerViewfinderDefaults: [String: Any] {
        let viewfinder = AimerViewfinder()
        return [
            "frameColor": viewfinder.frameColor.sdcHexString,
            "dotColor": viewfinder.dotColor.sdcHexString
        ]
    }
}
