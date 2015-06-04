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
    private var interval:UInt64 = 1
    
    /// Event that is executed repeatedly
    private var event: (() -> Void)!
    var Event: (() -> Void) {
        get {
            return event
        }
        set {
            event = newValue
            
            dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, NSEC_PER_SEC * interval, 0)
            dispatch_source_set_event_handler(timerSource, { () -> Void in
                self.event()
            })
        }
    }
    
    /**
    Init a GCD timer in a paused state.
    
    :param: intervalInSecs Time interval in seconds
    
    :returns: self
    */
    init(intervalInSecs: UInt64) {
        self.interval = intervalInSecs
    }
    
    /**
    Start the timer.
    */
    func start() {
        dispatch_resume(timerSource)
    }
    
    /**
    Pause the timer.
    */
    func pause() {
        dispatch_suspend(timerSource)
    }
}