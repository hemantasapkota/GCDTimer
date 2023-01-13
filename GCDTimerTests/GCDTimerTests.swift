//
//  GCDTimerTests.swift
//  GCDTimerTests
//
//  Created by Hemanta Sapkota on 4/06/2015.
//  Copyright (c) 2023 Hemanta Sapkota. All rights reserved.
//

import UIKit
import XCTest

class GCDTimerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTimerIsStartedOnce() {
        let timer = GCDTimer(intervalInSecs: 1)
        
        var index = 0
        timer.Event = {
            index += 1
            print("Hello \(index)")
        }
        
        // start the timer three times
        timer.start()
        timer.start()
        timer.start()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 5))
        XCTAssert(index >= 5, "Event should have run for at least 5 seconds.")
        
        index = 0
        
        timer.pause()
        
        timer.start()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 5))
        XCTAssert(index >= 5, "Event should have run for at least 5 seconds.")
    }
    
    func testTimer1() {
        let timer = GCDTimer(intervalInSecs: 1)
        
        var index = 0
        timer.Event = {
            index += 1
            print("Hello \(index)")
        }
        
        timer.start()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        
        XCTAssert(index > 10, "Event should have run for at least 10 seconds.")
    }

    func testTimer2() {
        let timer = GCDTimer(intervalInSecs: 0.1)

        var index = 0
        timer.Event = {
            index += 1
            print("Hello \(index)")
        }

        timer.start()

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))

        XCTAssert(index > 10, "Event should have run for at least 1 seconds.")
    }
    
    func testAutofinishingTimer() {
        let timer = GCDTimer(intervalInSecs: 1)
        
        var index = 0
        timer.Event = {
            index += 1
            print("Timer is running: \(index)")
            if index == 10 {
                timer.pause()
                index = 0
            }
        }
        
        timer.start()
        
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 10))
        
        XCTAssert(index == 0, "Timer should have paused.")
    }

    func testDelayedExecution() {
        var index = 0
        GCDTimer.delay(2, block: { () -> Void in
            index += 1
        })

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))

        XCTAssert(index == 0, "The block shouldn't have been executed")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))

        XCTAssert(index == 1, "The block should have executed after 2 secs.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
}
