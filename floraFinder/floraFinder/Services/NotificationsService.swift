//
//  NotificationsService.swift
//  floraFinder
//
//  Created by Al Stark on 14.04.2024.
//

import Foundation
import UserNotifications

public class NotificationsService {
    static let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {
        
    }
    
    public static func createNotification(identifier: String, title: String, description: String, trigger: Int) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = title
        content.body = description
        content.categoryIdentifier = "plantactions"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        notificationCenter.add(request)
    }
    
    public static func createWateringNotification(identifier: String, plant: String, triggerTime: Int) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "Полив"
        content.body = "Не забудьте полить \(plant)"
        content.categoryIdentifier = "plantactions"
        content.userInfo = ["plantID": identifier]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(triggerTime * 5), repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        notificationCenter.add(request)
    }
    
    public static func sendSuccessNotification(for plantID: String) {
        let content = UNMutableNotificationContent()
        content.title = "Полив завершен"
        content.body = "Растение было успешно полито!"
        
        let request = UNNotificationRequest(identifier: "SuccessNotification", content: content, trigger: nil)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Ошибка добавления уведомления: \(error.localizedDescription)")
            } else {
                print("Уведомление о успешном поливе отправлено")
            }
        }
    }
}
