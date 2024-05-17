//
//  MainEndpoint.swift
//  floraFinder
//
//  Created by Al Stark on 21.03.2024.
//

import Foundation
import UIKit


public extension NetworkEndpoint {
    enum Main {
        public static func allPlants(query: String = "") -> NetworkEndpoint {
            NetworkEndpoint(
                method: .get,
                path: "plants/\(query)",
                isAuthorizationRequired: false
            )
        }
        
        public static func allUserPlants() -> NetworkEndpoint {
            NetworkEndpoint(
                method: .get,
                path: "users/plants",
                isAuthorizationRequired: true
            )
        }
        
        public static func allUserDrugs() -> NetworkEndpoint {
            NetworkEndpoint(
                method: .get,
                path: "users/drugs",
                isAuthorizationRequired: true
            )
        }
    }
}

