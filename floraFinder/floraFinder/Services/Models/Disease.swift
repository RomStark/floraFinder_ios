//
//  Disease.swift
//  floraFinder
//
//  Created by Al Stark on 15.05.2024.
//

import Foundation
public struct Disease: Identifiable, Decodable {
    public var id: String {
        uuid
    }
    public let uuid: String
    public let name: String
    public let description: String
    public let drugs: [Drugs]
    
    enum CodingKeys: String, CodingKey {
        case uuid = "id"
        case name
        case description
        case drugs
    }
    
}

