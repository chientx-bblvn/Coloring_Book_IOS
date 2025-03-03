//
//  TimeoutChecker.swift
//  AdmobSDK
//
//  Created by Lê Minh Sơn on 10/11/24.
//

import Foundation

class TimeoutChecker: NSObject {
    private var timer: Timer?
    private var timeOut: TimeInterval = 20 // Timeout reach value
    private var timeCount: TimeInterval = 0 // Count to reach timeout
    
    private var onTick: ((_ time: TimeInterval) -> Void)?
    private var onTimedout: (() -> Void)?
    
    class func createChecker(timeout: TimeInterval,
                             onTick: ((_ time: TimeInterval) -> Void)? = nil,
                             onTimedout: @escaping (() -> Void)) -> TimeoutChecker {
        let timeoutChecker = TimeoutChecker()
        timeoutChecker.timeOut = timeout
        timeoutChecker.onTick = onTick
        timeoutChecker.onTimedout = onTimedout
        return timeoutChecker
    }
    
    func startChecker() {
        
        timeCount = 0
       
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.checkTimmer), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .common)
        
    }
    
    
    func stopChecker() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func checkTimmer() {
        self.timeCount += 1
        self.onTick?(timeOut - timeCount)
        print("\( self.timeCount)")
        if self.timeCount == timeOut {
            // time out
            self.stopChecker()
            self.onTimedout?()
        }
    }
}
