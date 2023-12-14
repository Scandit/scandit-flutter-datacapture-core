/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter

class FlutterDataCaptureView: UIView, FlutterPlatformView {
    weak var factory: FlutterCaptureViewFactory?

    func view() -> UIView {
        self
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        guard let index = factory?.views.firstIndex(of: self) else { return }
        factory?.views.remove(at: index)
        factory?.addCaptureViewToLastContainer()
    }

    override var frame: CGRect {
        didSet {
            guard let captureView = factory?.captureView, frame != .zero else {
                return
            }
            captureView.frame = frame
        }
    }
}
