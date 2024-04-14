//
//  MainService.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import RxSwift

public protocol MainService {
    func getAllPlants() -> Single<[Plant]>
    func getAllUserPlants() -> Single<[UserPlant]>
    func updatePlant(model: UpdatePlantDTO, id: String) -> Completable
}

public struct MainServiceImpl: MainService {
    public func getAllUserPlants() -> RxSwift.Single<[UserPlant]> {
        networkClient.requestModel(endpoint: .Main.allUserPlants())
    }
    
    public func getAllPlants() -> RxSwift.Single<[Plant]> {
        networkClient.requestModel(endpoint: .Main.allPlants())
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
