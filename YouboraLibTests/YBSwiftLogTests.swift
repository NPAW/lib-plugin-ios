//
//  YBSwiftLogTests.swift
//  YouboraLib
//
//  Created by Enrique Alfonso Burillo on 18/11/2019.
//  Copyright © 2019 NPAW. All rights reserved.
//

import XCTest

@objcMembers open class YBSwiftLogTests : XCTestCase, YBSwiftLogger {

    var delegateCallback: ((String,YBSwiftLogLevel) -> ())? = nil

    func testLogLevel() {
        YBSwiftLog.debugLevel = YBSwiftLogLevel.YBLogLevelError

        XCTAssertEqual(YBSwiftLogLevel.YBLogLevelError, YBSwiftLog.debugLevel)

        YBSwiftLog.debugLevel = YBSwiftLogLevel.YBLogLevelWarning

        XCTAssertEqual(YBSwiftLogLevel.YBLogLevelWarning, YBSwiftLog.debugLevel)
    }

    func testLogCallbacks() {
        var pendingCallbacks = 6

        self.delegateCallback = { message, level in
            pendingCallbacks -= 1
            switch pendingCallbacks {
            case 5:
                XCTAssertTrue(message.contains("requestLog"))
                XCTAssertEqual(YBSwiftLogLevel.YBLogLevelVerbose, level)
            case 4:
                XCTAssertTrue(message.contains("debug"))
                XCTAssertEqual(YBSwiftLogLevel.YBLogLevelDebug, level)
            case 3:
                XCTAssertTrue(message.contains("notice"))
                XCTAssertEqual(YBSwiftLogLevel.YBLogLevelNotice, level)
            case 2:
                XCTAssertTrue(message.contains("warn"))
                XCTAssertEqual(YBSwiftLogLevel.YBLogLevelWarning, level)
            case 1:
                XCTAssertTrue(message.contains("error"))
                XCTAssertEqual(YBSwiftLogLevel.YBLogLevelError, level)
            case 0:
                XCTAssertTrue(message.contains("Exception"))
                XCTAssertEqual(YBSwiftLogLevel.YBLogLevelError, level)
            default:
                XCTFail("unexpected pendingCallbacks")
            }
        }

        YBSwiftLog.addLoggerDelegate(self)
        YBSwiftLog.requestLog("requestLog")
        YBSwiftLog.debug("debug")
        YBSwiftLog.notice("notice")
        YBSwiftLog.warn("warn")
        YBSwiftLog.error("error")
        YBSwiftLog.logException(NSException.init(name: NSExceptionName.init("SampleException"), reason: "SampleReason", userInfo: nil))
    }

    func testAddRemoveLogger() {
        var callbackCount = 0
        self.delegateCallback = { message, level in
            callbackCount += 1
        }

        YBSwiftLog.addLoggerDelegate(self)

        YBSwiftLog.debug("debug") // 1

        // This shouldn't do anything
        YBSwiftLog.addLoggerDelegate(self)

        YBSwiftLog.notice("notice") //2
        YBSwiftLog.warn("warn") //3

        YBSwiftLog.removeLoggerDelegate(self)
        YBSwiftLog.removeLoggerDelegate(self)

        YBSwiftLog.debug("debug")
        YBSwiftLog.notice("notice")
        YBSwiftLog.warn("warn")

        XCTAssertEqual(3, callbackCount)
    }

    // Delegate
    public func logYoubora(message: String, logLevel: YBSwiftLogLevel) {
        if let callback = self.delegateCallback {
            callback(message, logLevel)
        }
    }
}
