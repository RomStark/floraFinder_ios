//
//  UserSettingsStorage.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import RxSwift

public final class UserSettingsStorage {
    
    public static let shared: UserSettingsStorage = UserSettingsStorage()
    private let defaults = UserDefaults.standard
        
    private init() {}
    
    public enum SettingsKeys: String {
        case userName
        case isAuthorized
        case login
        case password
    }
    
    public func save(key: SettingsKeys, value: Any?) -> Completable {
        Completable.create { [unowned self] completable in
            self.defaults.set(value, forKey: key.rawValue)
            
            // После выполнения сохранения, завершаем Completable
            completable(.completed)
            
            // Возвращаем disposable
            return Disposables.create()
        }
    }
    
//    public func saveLogin(value: Any?) -> Completable {
//        Completable.create { [unowned self] completable in
//            self.defaults.set(value, forKey: SettingsKeys.login.rawValue)
//            
//            // После выполнения сохранения, завершаем Completable
//            completable(.completed)
//            
//            // Возвращаем disposable
//            return Disposables.create()
//        }
//    }
    
    public func saveLogin(value: Any?)  {
        self.defaults.set(value, forKey: SettingsKeys.login.rawValue)
    }
    
    public func savePassword(value: Any?)  {
        
            self.defaults.set(value, forKey: SettingsKeys.password.rawValue)
            
    }
    
    public func save(key: SettingsKeys, value: Any?) {
        switch key {
        case .login, .password:
            self.defaults.set(
                true,
                forKey: SettingsKeys.isAuthorized.rawValue
            )
            self.defaults.set(value, forKey: key.rawValue)
        default:
            self.defaults.set(value, forKey: key.rawValue)
        }
    }
    
    public func retrieve<T>(key: SettingsKeys) -> T? {
        switch key {
        case .userName, .login, .password:
            return defaults.object(forKey: key.rawValue) as? T
        case .isAuthorized:
            return defaults.bool(forKey: key.rawValue) as? T
        }
    }
    
    public func clear(key: SettingsKeys) {
        defaults.set(nil, forKey: key.rawValue)
    }
}
