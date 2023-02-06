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
        if JSONValue.containsKey("type") {
            let type = JSONValue.string(forKey: "type")
            if type == "camera" {
                guard let camera = frameSource as? Camera else { return }
                camera.addListener(self)
                if JSONValue.containsKey("desiredState") {
                    let desiredStateJson = JSONValue.string(forKey: "desiredState")
                    var desiredState = FrameSourceState.on
                    if SDCFrameSourceStateFromJSONString(desiredStateJson, &desiredState) {
                        camera.switch(toDesiredState: desiredState)
                    }
                }
                if JSONValue.containsKey("desiredTorchState") {
                    let desiredTorchStateJson = JSONValue.string(forKey: "desiredTorchState")
                    var desiredTorchState = TorchState.off
                    if SDCTorchStateFromJSONString(desiredTorchStateJson, &desiredTorchState) {
                        camera.desiredTorchState = desiredTorchState
                    }
                }
            } else {
                guard let imageFrameSource = frameSource as? ImageFrameSource else { return }
                imageFrameSource.addListener(self)
                if JSONValue.containsKey("desiredState") {
                    let desiredStateJson = JSONValue.string(forKey: "desiredState")
                    var desiredState = FrameSourceState.on
                    if SDCFrameSourceStateFromJSONString(desiredStateJson, &desiredState) {
                        imageFrameSource.switch(toDesiredState: desiredState)
                    }
                }
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
