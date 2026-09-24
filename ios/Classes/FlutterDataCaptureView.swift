/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore

class FlutterDataCaptureView: UIView, FlutterPlatformView {
    weak var factory: FlutterCaptureViewFactory?
    weak var currentDataCaptureView: DataCaptureView?

    override var frame: CGRect {
        didSet {
            if frame != .zero, let captureView = currentDataCaptureView {
                captureView.frame = frame
            }
        }
    }

    func view() -> UIView {
        self
    }
    
    func attachDataCaptureView(dataCaptureView: DataCaptureView) {
        currentDataCaptureView = dataCaptureView
        if frame != .zero {
            dataCaptureView.frame = frame
        }
        addSubview(dataCaptureView)
    }

    override func removeFromSuperview() {
        if let dcView = currentDataCaptureView {
            factory?.coreModule.dataCaptureViewDisposed(dcView)
        }
        currentDataCaptureView = nil
        super.removeFromSuperview()
    }
}
