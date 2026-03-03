/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import Foundation

public class CallbackLock<ResultType> {

    enum Condition: Int {
        case noResult
        case result
    }

    private let name: String
    private var result: ResultType?

    let condition = NSCondition()
    var isCallbackFinished = true

    public init(name: String) {
        self.name = name
    }

    public func wait(afterDoing block: () -> Bool, timeout: Double = 2.0) -> ResultType? {
        let timeoutDate = Date(timeIntervalSinceNow: timeout)

        isCallbackFinished = false

        guard block() else {
            isCallbackFinished = false
            return result
        }

        condition.lock()
        while !isCallbackFinished {
            if !condition.wait(until: timeoutDate) {
                #if DEBUG
                print("Waited for a \(name) to finish for \(timeout) seconds")
                #endif
                isCallbackFinished = true
            }
        }
        condition.unlock()

        return result
    }

    public func unlock(value: ResultType?) {
        result = value
        release()
    }

    public func reset() {
        release()
    }

    private func release() {
        isCallbackFinished = true
        condition.signal()
    }
}
