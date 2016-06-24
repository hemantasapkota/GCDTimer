//
//  GCDTimer.swift
//  GCDTimer
//
//  Created by Hemanta Sapkota on 4/06/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import Foundation

/**
*  GCD Timer.
*/
public class GCDTimer {
    
    /// A serial queue for processing our timer tasks
    private static let gcdTimerQueue = dispatch_queue_create("gcdTimerQueue", DISPATCH_QUEUE_SERIAL)
    
    /// Timer Source
    private let timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, GCDTimer.gcdTimerQueue)
    
    /// Default internal: 1 second
    private var interval:Double = 1
    
    /// Ensure timer is started only once
    private var startOnceToken: Int = 0

    /// Event that is executed repeatedly
    private var event: (() -> Void)!
    public var Event: (() -> Void) {
        get {
            return event
        }
        set {
            event = newValue

            dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, UInt64(interval * Double(NSEC_PER_SEC)), 0)
            dispatch_source_set_event_handler(timerSource, { () -> Void in
                self.event()
            })
        }
    }
    
    /**
        Init a GCD timer in a paused state.

        - parameter intervalInSecs: Time interval in seconds
        
        - returns: self
    */
    public init(intervalInSecs: Double) {
        self.interval = intervalInSecs
    }
    
    /**
        Start the timer.
    */
    public func start() {
        dispatch_once(&startOnceToken) {
            dispatch_resume(self.timerSource)
        }
    }
    
    /**
        Pause the timer.
    */
    public func pause() {
        dispatch_suspend(timerSource)
        startOnceToken = 0
    }

    /**
        Executes a block after a delay on the main thread.
    */
    public class func delay(afterSecs: Double, block: dispatch_block_t) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(afterSecs * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), block)
    }

    /**
        Executes a block after a delay on a specified queue.
    */
    public class func delay(afterSecs: Double, queue: dispatch_queue_t, block: dispatch_block_t) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(afterSecs * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, queue, block)
    }
}