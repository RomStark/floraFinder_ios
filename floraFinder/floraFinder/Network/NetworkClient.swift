//
//  NetworkClient.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import RxSwift


public protocol NetworkClient {
    func request(endpoint: NetworkEndpoint) -> Single<Data>
    func requestModel<Model: Decodable>(endpoint: NetworkEndpoint) -> Single<Model>
}

public extension NetworkClient {
    func requestCompletable(endpoint: NetworkEndpoint) -> Completable {
        request(endpoint: endpoint).asCompletable()
    }
}
