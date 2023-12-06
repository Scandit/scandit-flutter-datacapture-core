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
            "logoStyle": view.logoStyle.jsonString,
            "focusGesture": view.focusGesture?.jsonString as Any,
            "zoomGesture": view.zoomGesture?.jsonString as Any
        ]
    }

    var laserlineViewfinderDefaults: [String: Any] {
        func createViewfinderDefaults(style: LaserlineViewfinderStyle) -> [String: Any] {
            let viewfinder = LaserlineViewfinder(style: style)
            let laserlineDefaults = [
                "width": viewfinder.width.jsonString,
                "enabledColor": viewfinder.enabledColor.sdcHexString,
                "disabledColor": viewfinder.disabledColor.sdcHexString,
                "style": viewfinder.style.jsonString
            ]
            return laserlineDefaults
        }
        return [
            "defaultStyle": LaserlineViewfinder().style.jsonString,
            "styles": [
                LaserlineViewfinderStyle.animated.jsonString: createViewfinderDefaults(style: .animated),
                LaserlineViewfinderStyle.legacy.jsonString: createViewfinderDefaults(style: .legacy)
            ]
        ]
    }

    var rectangularViewfinderDefaults: [String: Any] {
        func createViewfinderDefaults(style: RectangularViewfinderStyle) -> [String: Any] {
            let viewfinder = RectangularViewfinder(style: style)
            let rectangularDefaults = [
                "size": viewfinder.sizeWithUnitAndAspect.jsonString,
                "color": viewfinder.color.sdcHexString,
                "disabledColor": viewfinder.disabledColor.sdcHexString,
                "lineStyle": viewfinder.lineStyle.jsonString,
                "dimming": viewfinder.dimming,
                "animation": viewfinder.animation?.jsonString as Any,
                "style": viewfinder.style.jsonString,
                "disabledDimming": viewfinder.disabledDimming
            ]
            return rectangularDefaults
        }
        return [
            "defaultStyle": RectangularViewfinder().style.jsonString,
            "styles": [
                RectangularViewfinderStyle.square.jsonString: createViewfinderDefaults(style: .square),
                RectangularViewfinderStyle.rounded.jsonString: createViewfinderDefaults(style: .rounded),
                RectangularViewfinderStyle.legacy.jsonString: createViewfinderDefaults(style: .legacy)
            ]
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
