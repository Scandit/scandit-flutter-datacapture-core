/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

extension ScanditFlutterDataCaptureCore: FrameSourceDeserializerDelegate, FrameSourceListener, TorchListener {
    public func frameSource(_ source: FrameSource, didChange newState: FrameSourceState) {
        guard send(on: cameraStateEventSink, body: ["state": newState.jsonString]) else { return }
    }
    
    public func didChangeTorch(to torchState: TorchState) {
        guard send(on: cameraTorchStateEventSink, body: ["state": torchState.jsonString]) else { return }
    }

    public func frameSource(_ source: FrameSource, didOutputFrame frame: FrameData) {}

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didStartDeserializingFrameSource frameSource: FrameSource,
                                        from JSONValue: JSONValue) {}

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didFinishDeserializingFrameSource frameSource: FrameSource,
                                        from JSONValue: JSONValue) {
        guard let camera = frameSource as? Camera else { return }
        camera.addListener(self)
        camera.addTorchListener(self)

        if JSONValue.containsKey("desiredState") {
            let desiredStateJSON = JSONValue.string(forKey: "desiredState")
            var desiredState = FrameSourceState.on
            if SDCFrameSourceStateFromJSONString(desiredStateJSON, &desiredState) {
                camera.switch(toDesiredState: desiredState)
            }
        }
        if JSONValue.containsKey("desiredTorchState") {
            let desiredTorchStateJSON = JSONValue.string(forKey: "desiredTorchState")
            var desiredTorchState = TorchState.off
            if SDCTorchStateFromJSONString(desiredTorchStateJSON, &desiredTorchState) {
                camera.desiredTorchState = desiredTorchState
            }
        }
    }

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didStartDeserializingCameraSettings settings: CameraSettings,
                                        from JSONValue: JSONValue) {}

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didFinishDeserializingCameraSettings settings: CameraSettings,
                                        from JSONValue: JSONValue) {}
}
