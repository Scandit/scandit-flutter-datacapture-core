/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import ScanditFrameworksCore

@objc
class FlutterCaptureViewFactory: NSObject, FlutterPlatformViewFactory, DeserializationLifeCycleObserver {
    var captureView: DataCaptureView? {
        didSet {
            addCaptureViewToLastContainer()
        }
    }

    var views: [FlutterDataCaptureView] = []

    override init() {
        super.init()
        DeserializationLifeCycleDispatcher.shared.attach(observer: self)
    }

    deinit {
        DeserializationLifeCycleDispatcher.shared.detach(observer: self)
    }

    public func create(withFrame frame: CGRect,
                       viewIdentifier viewId: Int64,
                       arguments args: Any?) -> FlutterPlatformView {
        let flutterWrapperView = FlutterDataCaptureView(frame: frame)
        flutterWrapperView.factory = self
        views.append(flutterWrapperView)
        addCaptureViewToLastContainer()
        return flutterWrapperView
    }

    func addCaptureViewToLastContainer() {
        guard let captureView = captureView,
              let container = views.last else {
            return
        }
        if captureView.superview != nil && captureView.superview == container {
            // if attached to the same container do nothing. Removing and adding
            // it again might trigger something in the DataCaptureView that we don't
            // want. (overlay re-drawn, black screen, etc.)
            return
        }
        
        if captureView.superview != nil {
            captureView.removeFromSuperview()
        }
        if container.frame != .zero {
            captureView.frame = container.frame
        }
        container.addSubview(captureView)
    }

    func dataCaptureView(deserialized view: DataCaptureView?) {
        captureView = view
    }
}
