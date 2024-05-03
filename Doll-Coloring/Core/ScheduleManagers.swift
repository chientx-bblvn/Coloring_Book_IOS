//
//  ScheduleManagers.swift
//  BBLabs.
//
//  Created by BBLabs on 8/14/20.
//  Copyright © 2020 BBLabs.All rights reserved.
//

import UIKit

class ScheduleManagers: NSObject {
    
    private static var scheduleManager: ScheduleManagers?
    
    private var timerSchedule: Timer?
    
    override private init() {
        
    }
    
    static var shared: ScheduleManagers = {
        if scheduleManager == nil {
            scheduleManager = ScheduleManagers.init()
        }
        return scheduleManager!
    }()
    
    public func start(time: TimeInterval = 1) {
        stop()
        if timerSchedule == nil {
            NotificationCenter.default.post(name: .scheduleStarted, object: nil)
            timerSchedule = Timer.scheduledTimer(withTimeInterval: time, repeats: true, block: { (_) in
                NotificationCenter.default.post(name: .scheduleReached, object: nil)
            })
        }
        
    }
    
    public func stop() {
        if timerSchedule != nil {
            timerSchedule?.fire()
            timerSchedule?.invalidate()
            timerSchedule = nil
            NotificationCenter.default.post(name: .scheduleStopped, object: nil)
        }
    }
    
}
