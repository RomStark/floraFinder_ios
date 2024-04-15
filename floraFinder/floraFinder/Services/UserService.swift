//
//  UserService.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

//import Helpers
import RxSwift
//import Api


public protocol UserService {
    func login(login: String, password: String) -> Completable
    func signIn(login: String, password: String, name: String) -> Completable
    func logout() -> Completable
    func addPlant(model: AddPlantDTO) -> Single<UserPlant>
    func updatePlant(model: UpdatePlantDTO, id: String) -> Completable
    func wateringPlantBy(id: String) -> Completable
}

public struct UserServiceImpl: UserService {
    
    private let networkClient: NetworkClient
    
    public init(
        networkClient: NetworkClient
    ) {
        self.networkClient = networkClient
    }
    
    public func login(
        login: String,
        password: String
    ) -> Completable {
        networkClient.requestModel(endpoint: .User.login(login, password))
            .map({ (response: UserModel) in return response })
            .asCompletable()
    }
    
    public func signIn(
        login: String,
        password: String,
        name: String
    ) -> Completable {
        networkClient.requestModel(endpoint: .User.signIn(login, password, name: name))
            .map({ (response: UserModel) in return response })
            .asCompletable()
    }
    
    public func addPlant(model: AddPlantDTO) -> Single<UserPlant> {
        networkClient.requestModel(endpoint: .User.addPlant(model: model))
    }
    
    public func updatePlant(model: UpdatePlantDTO, id: String) -> Completable {
        networkClient.requestCompletable(endpoint: .User.updatePlant(model: model, id: id))
    }
    
    public func wateringPlantBy(id: String) -> Completable {
        networkClient.requestCompletable(endpoint: .User.wateringPlantById(id: id))
    }
    
    public func logout() -> Completable {
        networkClient.requestCompletable(endpoint: .User.logout())
//            .do(onError: errorHandler, onCompleted: tokenStorage.clear)
    }
}

