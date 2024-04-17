//
//  ImageResponse.swift
//  floraFinder
//
//  Created by Al Stark on 17.04.2024.
//

import Foundation
public struct ImageResponse: Decodable {
    
    public let className: Int
    public let real_name: String
    
    enum CodingKeys: String, CodingKey {
        case className = "class"
        case real_name
    }
}
