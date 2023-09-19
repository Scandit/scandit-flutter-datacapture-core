/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import Flutter
import ScanditFrameworksCore

public class FlutterFrameworkResult: FrameworksResult {
    let result: FlutterResult

    public init(reply: @escaping FlutterResult) {
        self.result = reply
    }

    public func success(result: Any?) {
        self.result(result)
    }

    public func reject(code: String, message: String?, details: Any?) {
        result(FlutterError(code: code, message: message, details: details))
    }

    public func reject(error: Error) {
        let error = error as NSError
        result(FlutterError(code: "\(error.code)",
                            message: error.localizedDescription,
                            details: error.userInfo))
    }
}
