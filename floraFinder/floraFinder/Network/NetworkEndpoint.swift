//
//  NetworkEndpoint.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import Foundation


public struct NetworkEndpoint {
    public let baseURL: URL
    public let path: String
    public let method: Method
    public let isAuthorizationRequired: Bool
    public let task: Task?
    
    init(
        method: NetworkEndpoint.Method,
        path: String,
        isAuthorizationRequired: Bool = true,
        task: NetworkEndpoint.Task? = nil,
        baseURL: URL = URL(string: "http://192.168.1.105:8080")!
    ) {
        self.path = path
        self.method = method
        self.isAuthorizationRequired = isAuthorizationRequired
        self.task = task
        self.baseURL = baseURL
    }

    public enum Method {
        case get, post, delete, path, put
    }

    public enum Task {
        case query(_ parameters: [String: Any?])
        case json([String: Any?])
        case formData(_ fields: [String: Any?])
        case multipart([Multipart])
        
        public struct Multipart {
            public enum Provider {
                case data(Data)
                case file(URL)
                case stream(InputStream, UInt64)
            }
            
            let provider: Provider
            let name: String
            let fileName: String?
            let mimeType: String?
            
            init(provider: Provider, name: String, fileName: String? = nil, mimeType: String? = nil) {
                self.provider = provider
                self.name = name
                self.fileName = fileName
                self.mimeType = mimeType
            }
            public static func data(_ data: Data, name: String, fileName: String? = nil, mimeType: String? = nil) -> Multipart {
                Multipart(provider: .data(data), name: name, fileName: fileName, mimeType: mimeType)
            }
        }
    }
}
