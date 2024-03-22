//
//  NetworkEndpoint.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import Foundation


public struct NetworkEndpoint {
    public let path: String
    public let method: Method
    public let isAuthorizationRequired: Bool
    public let task: Task?
    
    init(
        method: NetworkEndpoint.Method,
        path: String,
        isAuthorizationRequired: Bool = true,
        task: NetworkEndpoint.Task? = nil
    ) {
        self.path = path
        self.method = method
        self.isAuthorizationRequired = isAuthorizationRequired
        self.task = task
    }

    public enum Method {
        case get, post, delete, path, put
    }

    public enum Task {
        case query(_ parameters: [String: Any?])
        case json([String: Any?])
        case formData(_ fields: [String: Any?])
    }
}
