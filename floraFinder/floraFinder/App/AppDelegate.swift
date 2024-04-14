//
//  AppDelegate.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var appFlow: AppFlow!
    private var appDependencies: AppDependencies!
    private let notificationsCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        appDependencies = AppDependencies()
        
        appFlow = AppFlow(
            window: window,
            appDependencies: appDependencies
        )
        let wateringAction = UNNotificationAction(identifier: "wateringAction", title: "Полить", options: [])
        let category = UNNotificationCategory(identifier: "plantActions", actions: [wateringAction], intentIdentifiers: [], options: [])
        
        notificationsCenter.setNotificationCategories([category])
        notificationsCenter.delegate = self
        notificationsCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            guard granted else { return }
            self.notificationsCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
        
        appFlow.runAppFlow()
        
        return true
    }
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let userInfo = notification.request.content.userInfo
        print(response.actionIdentifier.description)
        print(notification.request.identifier)
        if response.actionIdentifier == "wateringAction" {
            // Получение id растения из userInfo и выполнение соответствующих действий по поливу
            if let plantID = userInfo["plantID"] as? String {
                // Здесь можно использовать plantID для выполнения действий по поливу растения
                print("Полив растения с id \(plantID)")
            }
        }
        
        completionHandler()
    }
}
