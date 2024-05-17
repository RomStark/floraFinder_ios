//
//  UserSettingsStorage.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import RxSwift
import Security


public final class UserSettingsStorage {
    
    public static let shared: UserSettingsStorage = UserSettingsStorage()
    private let defaults = UserDefaults.standard
        
    private init() {}
    
    public enum SettingsKeys: String {
        case userName
        case isAuthorized
        case login
        case password
        case latitude
        case longitude
    }
    
    public func savePasswordToKeychain(value: String) -> Bool {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: SettingsKeys.password.rawValue,
            kSecValueData as String: value.data(using: .utf8)!,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]

        // Удаляем старый пароль из Keychain, если он уже там есть
        let deleteResult = SecItemDelete(keychainQuery as CFDictionary)
        guard deleteResult == errSecSuccess || deleteResult == errSecItemNotFound else {
            print("Ошибка при удалении старого пароля из Keychain: \(deleteResult)")
            return false
        }

        // Добавляем новый пароль в Keychain
        let status = SecItemAdd(keychainQuery as CFDictionary, nil)
        guard status == errSecSuccess else {
            print("Ошибка при сохранении пароля в Keychain: \(status)")
            return false
        }

        return true
    }
    
    public func retrievePasswordFromKeychain() -> String? {
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: SettingsKeys.password.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(keychainQuery as CFDictionary, &dataTypeRef)

        guard status == errSecSuccess, let retrievedData = dataTypeRef as? Data else {
            print("Ошибка при извлечении пароля из Keychain: \(status)")
            return nil
        }

        return String(data: retrievedData, encoding: .utf8)
    }
    
    public func saveCompletable(key: SettingsKeys, value: Any?) -> Completable {
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
    
    public func savePassword(value: String)  {
        savePasswordToKeychain(value: value)
//            self.defaults.set(value, forKey: SettingsKeys.password.rawValue)
            
    }
    
    public func save(key: SettingsKeys, value: Any?) {
        switch key {
        case .login:
            self.defaults.set(
                true,
                forKey: SettingsKeys.isAuthorized.rawValue
            )
            self.defaults.set(value, forKey: key.rawValue)
        case .password:
            self.defaults.set(
                true,
                forKey: SettingsKeys.isAuthorized.rawValue
            )
            savePasswordToKeychain(value: SettingsKeys.isAuthorized.rawValue)
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
        case .latitude, .longitude:
            return defaults.float(forKey: key.rawValue) as? T
        }
    }
    
    public func retrieveLogin() -> String? {
        let login = defaults.object(forKey: SettingsKeys.login.rawValue) as? String
        return login
    }
    
    
    public func clear(key: SettingsKeys) {
        defaults.set(nil, forKey: key.rawValue)
    }
}
