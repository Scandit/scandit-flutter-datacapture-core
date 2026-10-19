/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import ScanditCaptureCoreDeserializer
import ScanditFrameworksCore

enum FunctionName {
    static let getDefaults = "getDefaults"
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
        DefaultServiceLocator.shared.register(module: coreModule)

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
        do {
            let defaultsJSONString = String(
                data: try JSONSerialization.data(
                    withJSONObject: coreModule.getDefaults(),
                    options: []
                ),
                encoding: .utf8
            )
            reply(defaultsJSONString)
        } catch {
            reply(error)
        }
    }

    public func handle(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case FunctionName.getDefaults:
            self.defaults(reply: result)
        case "executeCore":
            let handled = self.coreModule.execute(
                FlutterFrameworksMethodCall(methodCall),
                result: FlutterFrameworkResult(reply: result),
                module: self.coreModule
            )
            if !handled {
                result(FlutterError(code: "METHOD_NOT_FOUND", message: "Unknown Core method", details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
