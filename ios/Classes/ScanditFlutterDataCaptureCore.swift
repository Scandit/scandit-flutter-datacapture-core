/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore

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

@objc
public class ScanditFlutterDataCaptureCore: NSObject, FlutterPlatformViewFactory {

    private enum Errors {
        static let deserializationError = FlutterError(code: "1",
                                                       message: "Unable to deserialize a valid object.",
                                                       details: nil)
        static let nilDataCaptureViewError = FlutterError(code: "2",
                                                          message: "DataCaptureView is null.",
                                                          details: nil)
    }

    private let methodChannel: FlutterMethodChannel

    var context: DataCaptureContext? {
            willSet {
                context?.removeListener(self)
            }

            didSet {
                context?.addListener(self)
            }
        }

    let coreQueue = DispatchQueue(label: "com.scandit.flutter.datacapture-core")

    let contextStatusEventChannel: FlutterEventChannel
    let contextStatusEventSink = BaseEventSink()

    let didStartObservingContextEventChannel: FlutterEventChannel
    let didStartObservingContextEventSink = BaseEventSink()

    let viewDidChangeEventChannel: FlutterEventChannel
    let viewDidChangeEventSink = BaseEventSink()

    let cameraStateEventChannel: FlutterEventChannel
    let cameraStateEventSink = BaseEventSink()
    
    let cameraTorchStateEventChannel: FlutterEventChannel
    let cameraTorchStateEventSink = BaseEventSink()

    var dataCaptureView: DataCaptureView? {
        didSet {
            guard oldValue != dataCaptureView else { return }
            dataCaptureView?.addListener(self)
            wrappedView?.dataCaptureView = dataCaptureView
        }
    }

    var wrappedView: FlutterDataCaptureView?

    lazy var contextDeserializer: DataCaptureContextDeserializer = {
        let modeDeserializers = ScanditFlutterDataCaptureCore.modeDeserializers
        let componentDeserializers = ScanditFlutterDataCaptureCore.componentDeserializers
        let contextDeserializer = DataCaptureContextDeserializer(frameSourceDeserializer: frameSourceDeserializer,
                                                                 viewDeserializer: dataCaptureViewDeserializer,
                                                                 modeDeserializers: modeDeserializers,
                                                                 componentDeserializers: componentDeserializers)
        contextDeserializer.avoidThreadDependencies = true
        return contextDeserializer
    }()

    lazy var frameSourceDeserializer: FrameSourceDeserializer = {
        let deserializer = FrameSourceDeserializer(modeDeserializers: ScanditFlutterDataCaptureCore.modeDeserializers)
        deserializer.delegate = self
        return deserializer
    }()

    lazy var dataCaptureViewDeserializer: DataCaptureViewDeserializer = {
        return DataCaptureViewDeserializer(modeDeserializers: ScanditFlutterDataCaptureCore.modeDeserializers)
    }()

    static var modeDeserializers: [DataCaptureModeDeserializer] = []

    static var componentDeserializers: [DataCaptureComponentDeserializer] = []

    static var components: [DataCaptureComponent] = []

    fileprivate static var componentIds: Set<String> {
        Set(components.compactMap { $0.componentId })
    }

    public static func hasComponent(with id: String) -> Bool {
        return componentIds.contains(id)
    }

    public static func register(modeDeserializer: DataCaptureModeDeserializer) {
        modeDeserializers.removeAll { type(of: $0) == type(of: modeDeserializer) }
        modeDeserializers.append(modeDeserializer)
    }

    public static func register(componentDeserializer: DataCaptureComponentDeserializer) {
        componentDeserializers.append(componentDeserializer)
    }

    @objc
    public init(methodChannel: FlutterMethodChannel, messenger: FlutterBinaryMessenger) {
        self.methodChannel = methodChannel
        let didChangeStatusChannelName = "com.scandit.datacapture.core.event/datacapture_context#didChangeStatus"
        contextStatusEventChannel = FlutterEventChannel(name: didChangeStatusChannelName,
                                                        binaryMessenger: messenger)
        contextStatusEventChannel.setStreamHandler(contextStatusEventSink)
        let observingContextName = "com.scandit.datacapture.core.event/datacapture_context#didStartObservingContext"
        didStartObservingContextEventChannel = FlutterEventChannel(name: observingContextName,
                                                                   binaryMessenger: messenger)
        didStartObservingContextEventChannel.setStreamHandler(didStartObservingContextEventSink)
        let viewChangeSizeChannelName = "com.scandit.datacapture.core.event/datacapture_view#didChangeSize"
        viewDidChangeEventChannel = FlutterEventChannel(name: viewChangeSizeChannelName,
                                                        binaryMessenger: messenger)
        viewDidChangeEventChannel.setStreamHandler(viewDidChangeEventSink)
        cameraStateEventChannel = FlutterEventChannel(name: "com.scandit.datacapture.core.event/camera#didChangeState",
                                                      binaryMessenger: messenger)
        cameraStateEventChannel.setStreamHandler(cameraStateEventSink)
        cameraTorchStateEventChannel = FlutterEventChannel(name: "com.scandit.datacapture.core.event/camera#didChangeTorchState",
                                                      binaryMessenger: messenger)
        cameraTorchStateEventChannel.setStreamHandler(cameraTorchStateEventSink)
        super.init()
    }

    @objc
    public func dispose() {
        wrappedView?.removeFromSuperview()
        dataCaptureView?.removeFromSuperview()
        dataCaptureView?.removeListener(self)
        methodChannel.setMethodCallHandler(nil)
        contextStatusEventChannel.setStreamHandler(nil)
        didStartObservingContextEventChannel.setStreamHandler(nil)
        viewDidChangeEventChannel.setStreamHandler(nil)
        cameraStateEventChannel.setStreamHandler(nil)
        cameraTorchStateEventChannel.setStreamHandler(nil)
        context?.removeListener(self)
        context?.dispose()
    }

    public func create(withFrame frame: CGRect,
                       viewIdentifier viewId: Int64,
                       arguments args: Any?) -> FlutterPlatformView {
        let wrappedView = FlutterDataCaptureView(frame: frame == CGRect.zero ? UIScreen.main.bounds : frame)
        if dataCaptureView != nil {
            wrappedView.dataCaptureView = dataCaptureView!
        }
        self.wrappedView = wrappedView
        return wrappedView
    }

    func defaults(reply: FlutterReply) {
        let defaultsData = try! JSONSerialization.data(withJSONObject: defaults, options: [])
        let jsonString = String(data: defaultsData, encoding: .utf8)
        reply(jsonString)
    }

    func contextFromJSON(jsonString: String, reply: FlutterResult) {
        do {
            let result = try contextDeserializer.context(fromJSONString: jsonString)
            self.context = result.context
            self.dataCaptureView = result.view
            ScanditFlutterDataCaptureCore.components = result.components
            reply(nil)
        } catch let error as NSError {
            reply(FlutterError(code: "\(error.code)",
                               message: error.domain,
                               details: error.localizedDescription))
        }
    }

    func updateContextFromJSON(jsonString: String, reply: FlutterResult) {
        guard let context = self.context else {
            self.contextFromJSON(jsonString: jsonString, reply: reply)
            return
        }
        do {
            let components = ScanditFlutterDataCaptureCore.components
            let result = try self.contextDeserializer.update(context,
                                                             view: self.dataCaptureView,
                                                             components: components,
                                                             fromJSON: jsonString)
            self.context = result.context
            self.dataCaptureView = result.view
            ScanditFlutterDataCaptureCore.components = result.components
            reply(nil)
        } catch let error as NSError {
            reply(FlutterError(code: "\(error.code)",
                               message: error.domain,
                               details: error.localizedDescription))
        }
    }

    func cameraState(for positionString: String, reply: FlutterResult) {
        var position = CameraPosition.unspecified
        SDCCameraPositionFromJSONString(positionString, &position)
        let camera = Camera(position: position)
        let currentState = camera?.currentState ?? .off
        reply(currentState.jsonString)
    }

    func isTorchAvailable(for positionString: String, reply: FlutterResult) {
        var position = CameraPosition.unspecified
        SDCCameraPositionFromJSONString(positionString, &position)
        let camera = Camera(position: position)
        let isTorchAvailable = camera?.isTorchAvailable ?? false
        reply(isTorchAvailable)
    }

    func emitFeedback(_ feedbackJSON: String, reply: FlutterResult) {
        do {
            let feedback = try Feedback(fromJSONString: feedbackJSON)
            feedback.emit()
            reply(nil)
        } catch let error as NSError {
            reply(FlutterError(code: "\(error.code)",
                               message: error.domain,
                               details: error.localizedDescription))
        }
    }

    func viewPointForFramePoint(_ pointJSON: String, reply: FlutterResult) {
        guard let framePoint = CGPoint(json: pointJSON) else {
            reply(Errors.deserializationError)
            return
        }
        guard let captureView = self.dataCaptureView else {
            reply(Errors.nilDataCaptureViewError)
            return
        }
        let viewPoint = captureView.viewPoint(forFramePoint: framePoint)
        reply(viewPoint.jsonString)
    }

    func viewQuadrilateralForFrameQuadrilateral(_ quadrilateralJSON: String, reply: FlutterResult) {
        var quadrilateral = Quadrilateral()
        guard SDCQuadrilateralFromJSONString(quadrilateralJSON, &quadrilateral) else {
            reply(Errors.deserializationError)
            return
        }
        guard let captureView = self.dataCaptureView else {
            reply(Errors.nilDataCaptureViewError)
            return
        }
        let viewQuadrilateral = captureView.viewQuadrilateral(forFrameQuadrilateral: quadrilateral)
        reply(viewQuadrilateral.jsonString)
    }

    @objc
    public func handle(_ methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        coreQueue.async { [weak self] in
            guard let self = self else { return }
            switch methodCall.method {
            case FunctionName.getDefaults:
                self.defaults(reply: result)
            case FunctionName.updateContextFromJSON:
                DispatchQueue.main.async {
                    let contextString = methodCall.arguments as! String
                    self.updateContextFromJSON(jsonString: contextString, reply: result)
                }
            case FunctionName.getCameraState:
                let cameraPositionJSON = methodCall.arguments as! String
                self.cameraState(for: cameraPositionJSON, reply: result)
            case FunctionName.isTorchAvailable:
                let cameraPositionJSON = methodCall.arguments as! String
                self.isTorchAvailable(for: cameraPositionJSON, reply: result)
            case FunctionName.contextFromJSON:
                DispatchQueue.main.async {
                    let contextString = methodCall.arguments as! String
                    self.contextFromJSON(jsonString: contextString, reply: result)
                }
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
    }
}
