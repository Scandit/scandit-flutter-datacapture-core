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

    public func frameSource(_ source: FrameSource, didOutputFrame frame: FrameData) {
        // not used in frameworks
    }

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didStartDeserializingFrameSource frameSource: FrameSource,
                                        from jsonValue: JSONValue) {
        // not used in frameworks
    }

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didFinishDeserializingFrameSource frameSource: FrameSource,
                                        from jsonValue: JSONValue) {

        if !jsonValue.containsKey("type") {
            return
        }

        let type = jsonValue.string(forKey: "type")
        if type == "camera" {
            guard let camera = frameSource as? Camera else { return }
            camera.addListener(self)

            ifRequiredSetDesiredTorchState(jsonValue: jsonValue, camera: camera)
            ifRequiredSetFrameSourceState(jsonValue: jsonValue, frameSource: camera)

            return
        }

        guard let imageFrameSource = frameSource as? ImageFrameSource else { return }
        imageFrameSource.addListener(self)
        ifRequiredSetFrameSourceState(jsonValue: jsonValue, frameSource: imageFrameSource)
    }

    private func ifRequiredSetFrameSourceState(jsonValue: JSONValue, frameSource: FrameSource) {
        if !jsonValue.containsKey("desiredState") {
            return
        }

        let desiredStateJson = jsonValue.string(forKey: "desiredState")
        var desiredState = FrameSourceState.on
        if SDCFrameSourceStateFromJSONString(desiredStateJson, &desiredState) {
            frameSource.switch(toDesiredState: desiredState)
        }
    }

    private func ifRequiredSetDesiredTorchState(jsonValue: JSONValue, camera: Camera) {
        if !jsonValue.containsKey("desiredTorchState") {
            return
        }

        let desiredTorchStateJson = jsonValue.string(forKey: "desiredTorchState")
        var desiredTorchState = TorchState.off
        if SDCTorchStateFromJSONString(desiredTorchStateJson, &desiredTorchState) {
            camera.desiredTorchState = desiredTorchState
        }
    }

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didStartDeserializingCameraSettings settings: CameraSettings,
                                        from jsonValue: JSONValue) {
        // not used in frameworks
    }

    public func frameSourceDeserializer(_ deserializer: FrameSourceDeserializer,
                                        didFinishDeserializingCameraSettings settings: CameraSettings,
                                        from jsonValue: JSONValue) {
        // not used in frameworks
    }
}
