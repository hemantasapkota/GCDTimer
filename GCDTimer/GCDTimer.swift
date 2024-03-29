//
//  GCDTimer.swift
//  GCDTimer
//
//  Created by Hemanta Sapkota on 4/06/2015.
//  Copyright (c) 2023 Hemanta Sapkota. All rights reserved.
//

import Foundation

/**
*  GCD Timer.
*/
open class GCDTimer {
    
    // Swift 3 has removed support for dispatch_once. This class does the same thing ( roughly )
    class Once {
        
        private var _onceTracker = [String]()
        
        // From: http://stackoverflow.com/questions/37886994/dispatch-once-in-swift-3
        public func doIt(token: String, block:()->Void) {
            objc_sync_enter(self); defer { objc_sync_exit(self) }
            
            if _onceTracker.contains(token) {
                return
            }
            
            _onceTracker.append(token)
            block()

        }
        
        public func reset(token: String) {
            if let tokenIndex = _onceTracker.firstIndex(of: token) {
                _onceTracker.remove(at: tokenIndex)
            }
        }
        
    }
    
    /// A serial queue for processing our timer tasks
    fileprivate static let gcdTimerQueue = DispatchQueue(label: "gcdTimerQueue", attributes: [])
    
    /// Timer Source
    public let timerSource = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: GCDTimer.gcdTimerQueue)
    
    /// Default internal: 1 second
    fileprivate var interval:Double = 1
    
    /// dispatch_once alternative
    fileprivate let once = Once()
    
    /// Event that is executed repeatedly
    fileprivate var event: (() -> Void)!
    open var Event: (() -> Void) {
        get {
            return event
        }
        set {
            event = newValue
            
            self.timerSource.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(Int(interval)))
            self.timerSource.setEventHandler {
                self.event()
            }
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
    open func start() {
        once.doIt(token: "com.laex.GCDTimer") { () in
            self.timerSource.resume()
        }
    }
    
    /**
        Pause the timer.
    */
    open func pause() {
        timerSource.suspend()
        once.reset(token: "com.laex.GCDTimer")
    }

    /**
        Executes a block after a delay on the main thread.
    */
    open class func delay(_ afterSecs: Double, block: @escaping ()->()) {
        let delayTime = DispatchTime.now() + Double(Int64(afterSecs * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: block)
    }

    /**
        Executes a block after a delay on a specified queue.
    */
    open class func delay(_ afterSecs: Double, queue: DispatchQueue, block: @escaping ()->()) {
        let delayTime = DispatchTime.now() + Double(Int64(afterSecs * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: delayTime, execute: block)
    }
}
