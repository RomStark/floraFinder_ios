//
//  Plant.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import Foundation


public struct Plant: Identifiable, Decodable {
    
    public var id: String {
        
        uuid
    }
    public let imageURL: String?
    public let uuid: String
    public let name: String
    public let description: String
    public let minT: Int
    public let maxT: Int
    public let humidity: Int
    public let water_interval: Int
    public let lighting: String
    
    enum CodingKeys: String, CodingKey {
        case imageURL
        case uuid = "id"
        case name
        case description
        case minT
        case maxT
        case humidity
        case water_interval
        case lighting
    }
    
//    enum CodingKeys: String, CodingKey {
//        case image
//        case title
//        case text
//        case promoEndDate = "validity"
//    }
}

//public struct AllPlants: Decodable {
//    public let totalCount: Int?
//    public let items: [Plant]
//
//    enum CodingKeys: String, CodingKey {
//        case totalCount = "total_pages"
//        case items
//    }
//}
