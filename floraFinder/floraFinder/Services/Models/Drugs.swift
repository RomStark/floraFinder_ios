//
//  Drugs.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//

import Foundation
public struct Drugs: Identifiable, Decodable {
    public var id: String {
        uuid
    }
    public let uuid: String
    public let name: String
    public let price: Int
    public let description: String
    public let usingMethod: String
    public let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "id"
        case name
        case price
        case description
        case usingMethod = "using_method"
        case imageURL
    }
}

