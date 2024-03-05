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
}

public class ScanditFlutterDataCaptureCore: NSObject, FlutterPlugin, DeserializationLifeCycleObserver {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let eventChannel = FlutterEventChannel(name: "com.scandit.datacapture.core/event_channel",
                                               binaryMessenger: registrar.messenger())
        let methodChannel = FlutterMethodChannel(name: "com.scandit.datacapture.core/method_channel",
                                                 binaryMessenger: registrar.messenger())
        let eventEmitter = FlutterEventEmitter(eventChannel: eventChannel)
        let frameSourceListener = FrameworksFrameSourceListener(eventEmitter: eventEmitter)
        let frameSourceDeserializer = FrameworksFrameSourceDeserializer(frameSourceListener: frameSourceListener,
                                                                        torchListener: frameSourceListener)
        let contextListener = FrameworksDataCaptureContextListener(eventEmitter: eventEmitter)
        let viewListener = FrameworksDataCaptureViewListener(eventEmitter: eventEmitter)
        let coreModule = CoreModule(frameSourceDeserializer: frameSourceDeserializer,
                                    frameSourceListener: frameSourceListener,
                                    dataCaptureContextListener: contextListener,
                                    dataCaptureViewListener: viewListener)
        let corePlugin = ScanditFlutterDataCaptureCore(coreModule: coreModule, methodChannel: methodChannel)
        let captureViewFactory = FlutterCaptureViewFactory()

        registrar.addMethodCallDelegate(corePlugin, channel: methodChannel)
        registrar.register(captureViewFactory, withId: "com.scandit.DataCaptureView")

    }

    public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
        dispose()
    }

    private let methodChannel: FlutterMethodChannel
    private let coreModule: CoreModule

    public static var lastFrame: FrameData? {
        get {
            LastFrameData.shared.frameData
        }
        set {
            LastFrameData.shared.frameData = newValue
        }
    }

    public static func getLastFrameData(reply: @escaping FlutterResult) {
        LastFrameData.shared.getLastFrameDataJSON {
            reply($0)
        }
    }

    public static func register(modeDeserializer: DataCaptureModeDeserializer) {
        Deserializers.Factory.add(modeDeserializer)
    }

    public static func register(componentDeserializer: DataCaptureComponentDeserializer) {
        Deserializers.Factory.add(componentDeserializer)
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

    func viewPointForFramePoint(_ pointJSON: String, reply: @escaping FlutterResult) {
        coreModule.viewPointForFramePoint(json: pointJSON, result: FlutterFrameworkResult(reply: reply))
    }

    func viewQuadrilateralForFrameQuadrilateral(_ quadrilateralJSON: String,
                                                reply: @escaping FlutterResult) {
        coreModule.viewQuadrilateralForFrameQuadrilateral(json: quadrilateralJSON,
                                                          result: FlutterFrameworkResult(reply: reply))
    }

    public func handle(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        let handlerBlock = { [weak self] in
            guard let self = self else { return }
            switch methodCall.method {
            case FunctionName.getDefaults:
                self.defaults(reply: result)
            case FunctionName.updateContextFromJSON:
                let contextString = methodCall.arguments as! String
                self.updateContextFromJSON(jsonString: contextString, reply: result)
            case FunctionName.getCameraState:
                let cameraPositionJSON = methodCall.arguments as! String
                self.cameraState(for: cameraPositionJSON, reply: result)
            case FunctionName.isTorchAvailable:
                let cameraPositionJSON = methodCall.arguments as! String
                self.isTorchAvailable(for: cameraPositionJSON, reply: result)
            case FunctionName.contextFromJSON:
                let contextString = methodCall.arguments as! String
                self.contextFromJSON(jsonString: contextString, reply: result)
            case FunctionName.emitFeedback:
                let feedbackJSON = methodCall.arguments as! String
                self.emitFeedback(feedbackJSON, reply: result)
            case FunctionName.viewPointForFramePoint:
                let pointJSON = methodCall.arguments as! String
                self.viewPointForFramePoint(pointJSON, reply: result)
            case FunctionName.viewQuadrilateralForFrameQuadrilateral:
                let quadrilateralJSON = methodCall.arguments as! String
                self.viewQuadrilateralForFrameQuadrilateral(quadrilateralJSON, reply: result)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        dispatchMainSync(handlerBlock)
    }
}
