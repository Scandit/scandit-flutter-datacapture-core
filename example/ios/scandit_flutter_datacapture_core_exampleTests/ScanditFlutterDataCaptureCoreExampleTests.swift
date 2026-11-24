/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditCaptureCore
import XCTest
import scandit_flutter_datacapture_core

class ScanditFlutterDataCaptureCoreExampleTests: XCTestCase {

    static var messenger: FlutterBinaryMessenger!

    override class func setUp() {
        super.setUp()

        guard let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate,
            let flutterViewController = appDelegate.window.rootViewController as? FlutterViewController
        else {
            fatalError("The Flutter engine and the plugins are not set up.")
        }
        messenger = flutterViewController.binaryMessenger
    }

    func testMethodChannelIsCalledWithNotExistingMethodNameAndResultIsNotImplemented() {
        let messenger = ScanditFlutterDataCaptureCoreExampleTests.messenger
        let methodCall = FlutterMethodCall(methodName: "not-existing-method", arguments: nil)
        let channel = FlutterMethodChannel(
            name: "com.scandit.datacapture.core.method/datacapture_defaults",
            binaryMessenger: messenger!
        )
        let corePlugin = ScanditFlutterDataCaptureCore(methodChannel: channel, messenger: messenger!)
        corePlugin.handle(methodCall) { result in
            XCTAssert(result as! NSObject == FlutterMethodNotImplemented)
        }
    }

    // getDefaults() (the full blob) no longer exists (SDC-32178). getDynamicDefaults() carries
    // only the residual keys CoreDefaults can't resolve statically - see
    // CoreDefaultsDynamicTests.swift for the authoritative key set.
    func testGetDynamicDefaultsIsCallAllResidualDefaultsAreIncluded() {
        let messenger = ScanditFlutterDataCaptureCoreExampleTests.messenger
        let methodCall = FlutterMethodCall(methodName: "getDynamicDefaults", arguments: nil)
        let channel = FlutterMethodChannel(
            name: "com.scandit.datacapture.core.method/datacapture_defaults",
            binaryMessenger: messenger!
        )
        let corePlugin = ScanditFlutterDataCaptureCore(methodChannel: channel, messenger: messenger!)
        corePlugin.handle(methodCall) { result in
            let json =
                try! JSONSerialization.jsonObject(
                    with: (result as! String).data(using: .utf8)!,
                    options: []
                ) as! [String: Any]
            XCTAssertTrue(json.contains(where: { $0.key == "Version" }))
            XCTAssertTrue(json.contains(where: { $0.key == "Camera" }))
            XCTAssertTrue(json.contains(where: { $0.key == "deviceID" }))
        }
    }
}
