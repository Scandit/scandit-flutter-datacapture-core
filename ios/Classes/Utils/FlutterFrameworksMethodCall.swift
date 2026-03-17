/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import Foundation
import Flutter
import ScanditFrameworksCore

public class FlutterFrameworksMethodCall: FrameworksMethodCall {
    
    private let call: FlutterMethodCall
    
    public init(_ call: FlutterMethodCall) {
        self.call = call
    }
    
    public var method: String {
        return call.method
    }
    
    public func arguments<T>() -> T? {
        let processedArguments = processFlutterStandardTypedData(call.arguments)
        return processedArguments as? T
    }
    
    private func processFlutterStandardTypedData(_ value: Any?) -> Any? {
        guard let value = value else { return nil }
        
        // Handle FlutterStandardTypedData by extracting its .data property
        if let typedData = value as? FlutterStandardTypedData {
            return typedData.data
        }
        
        // Handle dictionaries recursively
        if let dict = value as? [String: Any] {
            var processedDict = [String: Any]()
            for (key, val) in dict {
                processedDict[key] = processFlutterStandardTypedData(val)
            }
            return processedDict
        }
        
        // Handle arrays recursively
        if let array = value as? [Any] {
            return array.map { processFlutterStandardTypedData($0) }
        }
        
        // Return the value as-is for other types
        return value
    }
    
    public func argument<T>(key: String) -> T? {
        guard let argumentsDict = call.arguments as? [String: Any] else {
            return nil
        }
        
        guard let value = argumentsDict[key] else {
            return nil
        }
        
        // Handle FlutterStandardTypedData by extracting its .data property
        if let typedData = value as? FlutterStandardTypedData {
            return typedData.data as? T
        }
        
        return value as? T
    }
    
    public func hasArgument(key: String) -> Bool {
        guard let argumentsDict = call.arguments as? [String: Any] else {
            return false
        }
        return argumentsDict.keys.contains(key)
    }
} 
