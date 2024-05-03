//
//  LocalNotificationManager.swift
//  Doll-Coloring
//
//  Created by BBLabs on 15/08/2023.
//

import UIKit

enum TypeNotify: Int {
    case schedule = 0
    case one = 1
}

class LocalNotificationManager: NSObject {
    
    static let shared = LocalNotificationManager()
    
    /**
     trigger: number seconds for fire to notification
     */
    
    func createNotification(title: String,
                            message: String,
                            imageName: String = "",
                            userInfo: [AnyHashable: Any] = [:],
                            time trigger: TimeInterval) {
        if trigger <= 0 {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: title, arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        content.launchImageName = imageName
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "notify-test"
        content.userInfo = userInfo
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: trigger, repeats: false)
        let request = UNNotificationRequest.init(identifier: "notify-test", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    func createAlarmAt(id: String,
                       title: String,
                       description: String,
                       hour: Int,
                       minute: Int,
                       weekday: Int = -1) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        if weekday >= 0 {
            dateComponents.weekday = weekday
        }
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: weekday >= 0)
        
        // Create the request
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        if weekday >= 0 {
            notificationCenter.removeDeliveredNotifications(withIdentifiers: ["\(id)-\(weekday)"])
            notificationCenter.removePendingNotificationRequests(withIdentifiers: ["\(id)-\(weekday)"])
        } else {
            notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        }
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    func createAlarmAtDaily(id: String,
                            title: String,
                            description: String,
                            hour: Int,
                            minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = description
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: true)
        
        // Create the request
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }
    }
    
    func deleteAlarm(id: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [id])
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}
