/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

extension ScanditFlutterDataCaptureCore: DataCaptureContextListener {
    public func context(_ context: DataCaptureContext, didChange frameSource: FrameSource?) {
        // not used in frameworks
    }

    public func context(_ context: DataCaptureContext, didAdd mode: DataCaptureMode) {
        // not used in frameworks
    }

    public func context(_ context: DataCaptureContext, didRemove mode: DataCaptureMode) {
        // not used in frameworks
    }

    public func context(_ context: DataCaptureContext, didChange contextStatus: ContextStatus) {
        guard send(on: contextStatusEventSink, body: ["status": contextStatus.jsonString]) else { return }
    }

    public func didStartObserving(_ context: DataCaptureContext) {
        guard send(on: didStartObservingContextEventSink,
                   body: ["licenseInfo": context.licenseInfo?.jsonString as Any]) else { return }
    }
}
