//
//  Notification++.swift
// Doll-Coloring
//
//  Created by BBLabs on 05/04/2023.
//  Copyright © 2024 BBLabs. All rights reserved.
//

import Foundation

public extension Notification.Name {
    static let reachabilityChanged = Notification.Name("reachabilityChanged")
    static let retryInternet = Notification.Name("retry_internet")
    static let notificationClicked = Notification.Name("notification_clicked")
    static let changeLanguage = Notification.Name("change_language")
    static let scheduleStarted = Notification.Name("schedule.manager.started")
    static let scheduleReached = Notification.Name("schedule.manager.reached")
    static let scheduleStopped = Notification.Name("schedule.manager.stopped")
}
