//
//  AppDependencies.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import Moya
import RxSwift
import RxRelay


final class AppDependencies {
    private var networkClient: NetworkClient!
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var services: Services = ServicesImpl(
        networkClient: networkClient
    )
    
    private var logout: () -> Void = { }
    
    init() {
        let password: String? = UserSettingsStorage.shared.retrieve(key: .password)
        let login: String? = UserSettingsStorage.shared.retrieve(key: .login)
        self.networkClient = MoyaApiClient(
            baseUrl: URL(string: "http://127.0.0.1:8080")!,
            plugins: [BasicAuthPlugin(username: login, password: password)]
        )
 
    }
    
   
    
    
    
    
    

    
    func setOnLogout(_ logout: @escaping () -> Void) {
        self.logout = logout
    }
    
    
    
    
}


// MARK: - Зависимость для загрузки изображений
protocol ImageLoadingDependencies {
    var imageLoader: ImageLoader { get }
}

extension AppDependencies: ImageLoadingDependencies {
    var imageLoader: ImageLoader {
        services.imageService.load(url:)
    }
}

// MARK: - Зависимости приложения

extension AppDependencies: MainScreenDependencies {
    var userService: UserService {
        services.authService
    }
    
    var mainService: MainService {
        services.mainService
    }
}

extension AppDependencies: AuthDependencies {
    var authService: UserService {
        services.authService
    }
}
