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
    public enum WeatherNotTitle: String{
        case сlear = "Солнечно"
        case clouds = "Облачно"
        case lowHumidity = "Низкая влажность"
        case highHumidity = "Высокая влажность"
    }
    
    public enum WeatherNotDesc: String{
        case clear = "Сегодня солнечно, проследите, чтобы растение не обожглось"
        case clouds = "Сегодня облачно, постарайтесь дать больше света цветам"
        case lowHumidity = "Сегодня низкая влажность, желательно опрыскивать растение"
        case highHumidity = "Сегодня высокая влажность, поливайте умеренно"
    }
    
    
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
    
    public static func createNotification(weather: WeatherNotTitle) {
        switch weather {
        case .highHumidity:
            self.createNotification(title: weather, description: .highHumidity)
        case .lowHumidity:
            self.createNotification(title: weather, description: .lowHumidity)
        case .сlear:
            self.createNotification(title: weather, description: .clear)
        case .clouds:
            self.createNotification(title: weather, description: .clouds)
        }
    }
    
    
    private static func createNotification(title: WeatherNotTitle, description: WeatherNotDesc) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        
        content.title = title.rawValue
        content.body = description.rawValue
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(10), repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        notificationCenter.add(request)
    }
    
    public static func createWateringNotification(plant: UserPlant) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "Полив"
        content.body = "Не забудьте полить \(plant.givenName)"
        content.categoryIdentifier = "plantactions"
        content.userInfo = ["plantID": plant.id]
        content.userInfo = ["plantID": plant.id, "humidity": plant.humidity, "wateringFrequency": plant.water_interval, "last_watering": plant.last_watering]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(plant.water_interval), repeats: false)
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
