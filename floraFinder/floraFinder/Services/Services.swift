//
//  Services.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import Foundation
//import Alamofire
//import Helpers
//import Api


public protocol Services {
    var imageService: KingfisherImageLoader { get }
    var mainService: MainService { get }
    var authService: UserService { get }
//    var database: Database { get }
}

public class ServicesImpl: Services {
    public let imageService: KingfisherImageLoader
    public let mainService: MainService
    public let authService: UserService
    
//    public let database: Database
    
    public init(
        networkClient: NetworkClient
//        tokenStorage: TokenStorage,
//        networkReachabilityManager: NetworkReachabilityManager?,
//        errorHandler: @escaping ErrorHandler
    ) {
        
        
        self.imageService = KingfisherImageLoader()
        self.mainService = MainServiceImpl(networkClient: networkClient)
        self.authService = UserServiceImpl(networkClient: networkClient)
    }
}

