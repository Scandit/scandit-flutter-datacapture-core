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

public extension FrameworksResult where Self == FlutterFrameworkResult {
    static func create(_ result: @escaping FlutterResult) -> Self {
        FlutterFrameworkResult(reply: result)
    }
}

public class FlutterLogInsteadOfResult: FrameworksResult {
    public init() { }

    public func success(result: Any?) {
        // nop
    }

    public func reject(code: String, message: String?, details: Any?) {
        print("ErrorCode: \(code); ErrorMessage: \(String(describing: message)); ErrorDetails:\(String(describing: details))")
    }

    public func reject(error: Error) {
        print(error)
    }
}
