//
//  UserEndpoint.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import Foundation
import UIKit
import Moya


public extension NetworkEndpoint {
    enum User {
        public static func login(_ login: String, _ password: String) -> NetworkEndpoint {
            NetworkEndpoint(
                method: .post,
                path: "users/auth",
                isAuthorizationRequired: false,
                task: .json(["login": login,
                             "password": password])
            )
        }
        
        public static func signIn(_ login: String, _ password: String, name: String) -> NetworkEndpoint {
            NetworkEndpoint(
                method: .post,
                path: "users/signIn",
                isAuthorizationRequired: false,
                task: .json(["name": name,
                             "login": login,
                             "password": password])
            )
        }
        
        public static func addPlant(model: AddPlantDTO) -> NetworkEndpoint {
            let data = try? asDictionary(model: model)
            return NetworkEndpoint(
                method: .post,
                path: "users/plants",
                isAuthorizationRequired: true,
                task: .formData(data ?? [:])
            )
        }
        
        public static func updatePlant(model: UpdatePlantDTO, id: String) -> NetworkEndpoint {
            let data = try? asDictionary(model: model)
            return NetworkEndpoint(
                method: .put,
                path: "users/plants/\(id)",
                isAuthorizationRequired: true,
                task: .formData(data ?? [:])
            )
        }
        
        public static func wateringPlantById(id: String) -> NetworkEndpoint {
            return NetworkEndpoint(
                method: .get,
                path: "users/plants/watering/\(id)",
                isAuthorizationRequired: true
            )
        }
        
        public static func getName(id: String) -> NetworkEndpoint {
            return NetworkEndpoint(
                method: .get,
                path: "users/plants/watering/\(id)",
                isAuthorizationRequired: true
            )
        }
        
        public static func logout() -> NetworkEndpoint {
            NetworkEndpoint(
                method: .get,
                path: "/auth/logout"
            )
        }
        
        public static func sendImage(data: Data) -> NetworkEndpoint {
            NetworkEndpoint(
                method: .post,
                path: "/predict/plant",
                isAuthorizationRequired: false,
                task: .multipart([.data(data, name: "image", fileName: "image.jpg", mimeType: "image/jpeg")]),
                baseURL: URL(string: "http://192.168.1.102:8000")!
            )
        }
        
        public static func sendDiseaseImage(data: Data) -> NetworkEndpoint {
            NetworkEndpoint(
                method: .post,
                path: "/predict/disease",
                isAuthorizationRequired: false,
                task: .multipart([.data(data, name: "image", fileName: "image.jpg", mimeType: "image/jpeg")]),
                baseURL: URL(string: "http://192.168.1.102:8000")!
            )
        }
        
        public static func deletePlant(id: String) -> NetworkEndpoint {
            NetworkEndpoint(
                method: .delete,
                path: "users/plants/\(id)",
                isAuthorizationRequired: true)
        }
    }
}

public struct AddPlantDTO: Codable {
    public var givenName: String
    public var name: String
    public var description: String
    public var minT: Int
    public var maxT: Int
    public var humidity: Int
    public var water_interval: Int
    public var lighting: String
    public var imageURL: String?
    public var last_watering: Int
}

public struct UpdatePlantDTO: Codable {
    public var givenName: String
    public var name: String
    public var description: String
    public var minT: Int
    public var maxT: Int
    public var humidity: Int
    public var water_interval: Int
    public var lighting: String
    public var imageURL: String?
    public var last_watering: Int
}

public func asDictionary(model: Codable) throws -> [String: Any?]? {
    let jsonEncoder = JSONEncoder()
    let jsonData = try jsonEncoder.encode(model)
    return try JSONSerialization.jsonObject(with: jsonData) as? [String: Any?]
}
