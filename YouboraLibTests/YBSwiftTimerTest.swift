//
//  YBSwiftTimerTest.swift
//  YouboraLib
//
//  Created by nice on 22/01/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBSwiftTimerTests: XCTestCase {
    func testIsRunning() {
        let timer = YBSwiftTimer(callback: {_, _  in })

        XCTAssertFalse(timer.isRunning)

        timer.start()

        XCTAssertTrue(timer.isRunning)

        timer.stop()

        XCTAssertFalse(timer.isRunning)
    }

    func testTicks() {
        var ticks = 3

        let expectation = self.expectation(description: "callback called")

        let callback1: SwiftTimerCallback = {(timer, diffTime) in
            ticks -= 1
            XCTAssertNotEqual(0, diffTime)
            if ticks == 0 {
                expectation.fulfill()
            }
        }

        let callback2: SwiftTimerCallback = {(timer, diffTime) in
            ticks -= 1
            XCTAssertNotEqual(0, diffTime)
            if ticks == 0 {
                expectation.fulfill()
            }
        }

        let timer = YBSwiftTimer(callback: callback1, andInterval: 10)

        timer.addTimerCallback(callback2)

        timer.start()

        self.waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
