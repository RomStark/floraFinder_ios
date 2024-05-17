//
//  LocationManager.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private let userSettingsStorage = UserSettingsStorage.shared
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Сохраняем координаты в UserDefaults
        let latitude = Float(location.coordinate.latitude.value)
        let longitude = Float(location.coordinate.longitude.value)
        self.userSettingsStorage.save(key: .latitude, value: latitude)
        self.userSettingsStorage.save(key: .longitude, value: longitude)
        
        // Можно также остановить обновление местоположения, если оно больше не нужно
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
