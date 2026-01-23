/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import ScanditFrameworksCore

@objc
class FlutterCaptureViewFactory: NSObject, FlutterPlatformViewFactory {
    
    let coreModule: CoreModule

    init(coreModule: CoreModule) {
        self.coreModule = coreModule
        super.init()
    }


    public func create(withFrame frame: CGRect,
                       viewIdentifier viewId: Int64,
                       arguments args: Any?) -> FlutterPlatformView {
        
        guard let creationArgs = args as? [String: Any] else {
            Log.error("Unable to create DataCaptureView without the JSON.")
            fatalError("Unable to create DataCaptureView without the JSON.")
        }
        guard let creationJson = creationArgs["DataCaptureView"] as? String else {
            Log.error("Unable to create the DataCaptureView without the json.")
            fatalError("Unable to create the DataCaptureView without the json.")
        }
        
        
        let flutterWrapperView = FlutterDataCaptureView(frame: frame)
        flutterWrapperView.factory = self
        
        if let dcView = coreModule.createDataCaptureView(viewJson: creationJson,
                                                         result: FlutterLogInsteadOfResult()) {
            
            flutterWrapperView.attachDataCaptureView(dataCaptureView: dcView)
        }

        return flutterWrapperView
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}
