//
//  MainService.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift

public protocol MainService {
    func getAllPlants(query: String) -> Single<[Plant]>
    func getAllUserPlants() -> Single<[UserPlant]>
    func updatePlant(model: UpdatePlantDTO, id: String) -> Completable
    func getUserDrugs() -> Single<[Drugs]>
}

public struct MainServiceImpl: MainService {
    public func getUserDrugs() -> RxSwift.Single<[Drugs]> {
        networkClient.requestModel(endpoint: .Main.allUserDrugs())
    }
    
    public func getAllUserPlants() -> RxSwift.Single<[UserPlant]> {
        networkClient.requestModel(endpoint: .Main.allUserPlants())
    }
    
    public func getAllPlants(query: String = "") -> RxSwift.Single<[Plant]> {
        networkClient.requestModel(endpoint: .Main.allPlants(query: query))
    }
    
    public func updatePlant(model: UpdatePlantDTO, id: String) -> Completable {
        networkClient.requestCompletable(endpoint: .User.updatePlant(model: model, id: id))
    }
    
    private let networkClient: NetworkClient
    
    public init(
        networkClient: NetworkClient
    ) {
        self.networkClient = networkClient
    }
}
