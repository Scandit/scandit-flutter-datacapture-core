/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

class FlutterDataCaptureView: UIView, FlutterPlatformView {
    var dataCaptureView: DataCaptureView? {
        didSet {
            if let captureView = dataCaptureView {
                addSubview(captureView)
                captureView.frame = frame
            }
        }
    }

    override var frame: CGRect {
        didSet {
            dataCaptureView?.frame = frame
        }
    }

    func view() -> UIView {
        return self
    }
}
