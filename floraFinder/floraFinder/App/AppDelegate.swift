//
//  AppDelegate.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import UIKit
import UserNotifications
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var appFlow: AppFlow!
    private var appDependencies: AppDependencies!
    private let notificationsCenter = UNUserNotificationCenter.current()
    private let disposeBag = DisposeBag()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        appDependencies = AppDependencies()
        
        appFlow = AppFlow(
            window: window,
            appDependencies: appDependencies
        )
        
        let wateringAction = UNNotificationAction(identifier: "wateringAction", title: "Полить", options: [])
        let category = UNNotificationCategory(identifier: "plantactions", actions: [wateringAction], intentIdentifiers: [], options: [])
        notificationsCenter.removeAllDeliveredNotifications()
        notificationsCenter.removeAllPendingNotificationRequests()
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
        if response.actionIdentifier == "wateringAction" {
            if let plantID = userInfo["plantID"] as? String {
                NotificationsService.sendSuccessNotification(for: plantID)
                appDependencies.userService.wateringPlantBy(id: plantID).subscribe(onCompleted: {
                    NotificationsService.sendSuccessNotification(for: plantID)
                }).disposed(by: disposeBag)
            }
        }
        
        completionHandler()
    }
}
