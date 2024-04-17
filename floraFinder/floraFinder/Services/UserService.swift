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
    func sendImage(data: Data) -> Single<ImageResponse>
    func getAllPlants(query: String) -> Single<[Plant]>
    func deletePlant(id: String) -> Completable
}

public struct UserServiceImpl: UserService {
    
    private let networkClient: NetworkClient
    
    public init(
        networkClient: NetworkClient
    ) {
        self.networkClient = networkClient
    }
    
    public func getAllPlants(query: String = "") -> RxSwift.Single<[Plant]> {
        networkClient.requestModel(endpoint: .Main.allPlants(query: query))
    }
    
    public func sendImage(data: Data) -> Single<ImageResponse> {
        networkClient.requestModel(endpoint: .User.sendImage(data: data))
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
    
    public func deletePlant(id: String) -> Completable {
        networkClient.requestCompletable(endpoint: .User.deletePlant(id: id))
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

