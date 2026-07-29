/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import ScanditFrameworksCore

enum FunctionName {
    static let getDefaults = "getDefaults"
    static let updateContextFromJSON = "updateContextFromJSON"
    static let contextFromJSON = "createContextFromJSON"
    static let getCameraState = "getCameraState"
    static let isTorchAvailable = "isTorchAvailable"
    static let emitFeedback = "emitFeedback"
    static let viewPointForFramePoint = "viewPointForFramePoint"
    static let viewQuadrilateralForFrameQuadrilateral = "viewQuadrilateralForFrameQuadrilateral"
    static let switchCameraToDesiredState = "switchCameraToDesiredState"
    static let addModeToContext = "addModeToContext"
    static let removeModeFromContext = "removeModeFromContext"
    static let removeAllModesFromContext = "removeAllModesFromContext"
    static let updateDataCaptureView = "updateDataCaptureView"
    static let addOverlay = "addOverlay"
    static let removeOverlay = "removeOverlay"
    static let removeAllOverlays = "removeAllOverlays"
    static let getOpenSourceSoftwareLicenseInfo = "getOpenSourceSoftwareLicenseInfo"
}

public class ScanditFlutterDataCaptureCore: NSObject, FlutterPlugin, DeserializationLifeCycleObserver {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let eventChannel = FlutterEventChannel(
            name: "com.scandit.datacapture.core/event_channel",
            binaryMessenger: registrar.messenger()
        )
        let methodChannel = FlutterMethodChannel(
            name: "com.scandit.datacapture.core/method_channel",
            binaryMessenger: registrar.messenger()
        )

        let eventEmitter = FlutterEventEmitter(eventChannel: eventChannel)
        let coreModule = CoreModule.create(emitter: eventEmitter)
        let corePlugin = ScanditFlutterDataCaptureCore(coreModule: coreModule, methodChannel: methodChannel)
        registrar.addMethodCallDelegate(corePlugin, channel: methodChannel)

        let captureViewFactory = FlutterCaptureViewFactory(coreModule: coreModule)
        registrar.register(captureViewFactory, withId: "com.scandit.DataCaptureView")

    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        dispose()
    }

    private let methodChannel: FlutterMethodChannel
    private let coreModule: CoreModule

    public static func register(modeDeserializer: DataCaptureModeDeserializer) {
        Deserializers.Factory.add(modeDeserializer)
    }

    public init(coreModule: CoreModule, methodChannel: FlutterMethodChannel) {
        self.coreModule = coreModule
        self.methodChannel = methodChannel
        coreModule.didStart()
        super.init()
        DeserializationLifeCycleDispatcher.shared.attach(observer: self)
    }

    func dispose() {
        methodChannel.setMethodCallHandler(nil)
        coreModule.didStop()
    }

    func defaults(reply: FlutterReply) {
        let jsonString = coreModule.defaults.stringValue
        reply(jsonString)
    }

    func contextFromJSON(jsonString: String, reply: @escaping FlutterResult) {
        coreModule.createContextFromJSON(jsonString, result: FlutterFrameworkResult(reply: reply))
    }

    func updateContextFromJSON(jsonString: String, reply: @escaping FlutterResult) {
        coreModule.updateContextFromJSON(jsonString, result: FlutterFrameworkResult(reply: reply))
    }

    func cameraState(for positionString: String, reply: @escaping FlutterResult) {
        coreModule.getCameraState(cameraPosition: positionString, result: FlutterFrameworkResult(reply: reply))
    }

    func isTorchAvailable(for positionString: String, reply: @escaping FlutterResult) {
        coreModule.isTorchAvailable(cameraPosition: positionString, result: FlutterFrameworkResult(reply: reply))
    }

    func emitFeedback(_ feedbackJSON: String, reply: @escaping FlutterResult) {
        coreModule.emitFeedback(json: feedbackJSON, result: FlutterFrameworkResult(reply: reply))
    }

    func viewPointForFramePoint(_ viewId: Int, pointJSON: String, reply: @escaping FlutterResult) {
        coreModule.viewPointForFramePoint(viewId: viewId, json: pointJSON, result: FlutterFrameworkResult(reply: reply))
    }

    func viewQuadrilateralForFrameQuadrilateral(
        _ viewId: Int,
        quadrilateralJSON: String,
        reply: @escaping FlutterResult
    ) {
        coreModule.viewQuadrilateralForFrameQuadrilateral(
            viewId: viewId,
            json: quadrilateralJSON,
            result: FlutterFrameworkResult(reply: reply)
        )
    }

    public func handle(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let handlerBlock = { [weak self] in
            guard let self = self else { return }
            switch methodCall.method {
            case FunctionName.getDefaults:
                self.defaults(reply: result)
            case FunctionName.updateContextFromJSON:
                guard let contextString = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.updateContextFromJSON(jsonString: contextString, reply: result)
            case FunctionName.getCameraState:
                guard let cameraPositionJSON = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.cameraState(for: cameraPositionJSON, reply: result)
            case FunctionName.isTorchAvailable:
                guard let cameraPositionJSON = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.isTorchAvailable(for: cameraPositionJSON, reply: result)
            case FunctionName.contextFromJSON:
                guard let contextString = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.contextFromJSON(jsonString: contextString, reply: result)
            case FunctionName.emitFeedback:
                guard let feedbackJSON = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.emitFeedback(feedbackJSON, reply: result)
            case FunctionName.viewPointForFramePoint:
                guard let args = methodCall.arguments as? [String: Any?] else {
                    result(
                        FlutterError(
                            code: "-1",
                            message: "Invalid argument for \(FunctionName.viewPointForFramePoint)",
                            details: methodCall.arguments
                        )
                    )
                    return
                }

                guard let viewId = args["viewId"] as? Int,
                    let pointJSON = args["point"] as? String
                else {
                    result(
                        FlutterError(
                            code: "-1",
                            message: "Invalid argument for \(FunctionName.viewPointForFramePoint)",
                            details: methodCall.arguments
                        )
                    )
                    return
                }
                self.viewPointForFramePoint(viewId, pointJSON: pointJSON, reply: result)
            case FunctionName.viewQuadrilateralForFrameQuadrilateral:
                guard let args = methodCall.arguments as? [String: Any?] else {
                    result(
                        FlutterError(
                            code: "-1",
                            message: "Invalid argument for \(FunctionName.viewPointForFramePoint)",
                            details: methodCall.arguments
                        )
                    )
                    return
                }

                guard let viewId = args["viewId"] as? Int,
                    let quadrilateralJSON = args["quadrilateral"] as? String
                else {
                    result(
                        FlutterError(
                            code: "-1",
                            message: "Invalid argument for \(FunctionName.viewPointForFramePoint)",
                            details: methodCall.arguments
                        )
                    )
                    return
                }
                self.viewQuadrilateralForFrameQuadrilateral(viewId, quadrilateralJSON: quadrilateralJSON, reply: result)
            case FunctionName.switchCameraToDesiredState:
                guard let desiredStateJson = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.coreModule.switchCameraToDesiredState(
                    stateJson: desiredStateJson,
                    result: FlutterFrameworkResult(reply: result)
                )
            case FunctionName.addModeToContext:
                guard let modeJson = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.coreModule.addModeToContext(modeJson: modeJson, result: FlutterFrameworkResult(reply: result))
            case FunctionName.removeModeFromContext:
                guard let modeJson = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.coreModule.removeModeFromContext(modeJson: modeJson, result: FlutterFrameworkResult(reply: result))
            case FunctionName.removeAllModesFromContext:
                self.coreModule.removeAllModes(result: FlutterFrameworkResult(reply: result))
            case FunctionName.updateDataCaptureView:
                guard let viewJson = methodCall.arguments as? String else {
                    result(FlutterError(code: "-1", message: "Invalid argument", details: nil))
                    return
                }
                self.coreModule.updateDataCaptureView(viewJson: viewJson, result: FlutterFrameworkResult(reply: result))
            case FunctionName.getOpenSourceSoftwareLicenseInfo:
                self.coreModule.getOpenSourceSoftwareLicenseInfo(result: FlutterFrameworkResult(reply: result))
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        dispatchMain(handlerBlock)
    }
}
