//
//  AppDelegate.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import UIKit
import UserNotifications
import RxSwift
import BackgroundTasks

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
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
       
        
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
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60 * 60 * 24)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }
    
    func handleAppRefresh(task: BGAppRefreshTask) {
        let lon: Float? = UserSettingsStorage.shared.retrieve(key: .longitude)
        let lat: Float? = UserSettingsStorage.shared.retrieve(key: .latitude)
        if lon == 0.0 {
            task.setTaskCompleted(success: false)
            return
        }
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=fae0174a50c1ea243b612773fdb4157a") else {
            print("Invalid URL")
            task.setTaskCompleted(success: false)
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                task.setTaskCompleted(success: false)
                return
            }
            
            guard let data = data else {
                print("No data received")
                task.setTaskCompleted(success: false)
                return
            }
            
            do {
                let data = try JSONDecoder().decode(WeatherInfoModel.self, from: data)
                self?.updateNotificationTimers(with: data.main.humidity)
                if data.main.humidity < 50 {
                    NotificationsService.createNotification(weather: .lowHumidity)
                } else {
                    NotificationsService.createNotification(weather: .highHumidity)
                }
                if data.weather[0].main == "Clouds" {
                    NotificationsService.createNotification(weather: .clouds)
                }
                if data.weather[0].main == "Clear" {
                    NotificationsService.createNotification(weather: .сlear)
                }
                task.setTaskCompleted(success: true)
            } catch {
                print("Error decoding JSON: \(error)")
                task.setTaskCompleted(success: false)
            }
        }
        
        dataTask.resume()
    }
    
    
    
    func updateNotificationTimers(with humidity: Int) {
        notificationsCenter.getPendingNotificationRequests { requests in
            for request in requests {
                let userInfo = request.content.userInfo
                if let trigger = request.trigger as? UNTimeIntervalNotificationTrigger,
                   let lastWatering = userInfo["last_watering"] as? Int,
                   let idealHumidity = userInfo["humidity"] as? Int,
                   let wateringFrequency = userInfo["wateringFrequency"] as? Int {
                    
                    let idealTimeInterval = 86400 * Double(wateringFrequency)
                    let deviationFactor = (1.0 - abs(Double(humidity - idealHumidity) / Double(idealHumidity)))
                    var newTimeInterval = Int(idealTimeInterval * deviationFactor) - (Int(Date(timeIntervalSinceNow: 0).timeIntervalSince1970) - lastWatering)
                    if newTimeInterval < 24 * 60 * 60 {
                        newTimeInterval = 60 * 60
                    }
                    let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(newTimeInterval), repeats: trigger.repeats)
                    
                    
                    let newRequest = UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: newTrigger)
                    
                    self.notificationsCenter.add(newRequest) { error in
                        if let error = error {
                            print("Ошибка при обновлении уведомления: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
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
                appDependencies.userService.wateringPlantBy(id: plantID).subscribe(onCompleted: {
                    NotificationsService.sendSuccessNotification(for: plantID)
                }).disposed(by: disposeBag)
            }
        }
        completionHandler()
    }
}
