//
//  MoyaClient.swift
//  floraFinder
//
//  Created by Al Stark on 20.03.2024.
//

import Foundation
import Moya
import RxSwift


public final class MoyaApiClient: NSObject, NetworkClient {
    public typealias TokenProvider = () -> String?
    
    private var provider: MoyaProvider<MoyaTarget>!
    
    private let queue = DispatchQueue(
        label: ProcessInfo.processInfo.globallyUniqueString,
        qos: .background,
        attributes: .concurrent
    )
    
    private let baseUrl: URL
    private let decoder = JSONDecoder()
    
    public init(baseUrl: URL, plugins: [PluginType] = []) {
        self.baseUrl = baseUrl
        
        super.init()
        
        provider = MoyaProvider<MoyaTarget>(
            callbackQueue: queue,
            plugins: plugins
        )
    }
    
    public func request(endpoint: NetworkEndpoint) -> Single<Data> {
        return provider.rx
            .request(target(endpoint: endpoint))
            .filterSuccessfulStatusAndRedirectCodes()
        //            .catchError({
        //                if NetworkReachabilityManager.default?.isReachable == false {
        //                    throw Error
        //                } else {
        //                    throw $0
        //                }
        //            })
            .map({ response in response.data })
    }
    
    public func requestModel<Model>(endpoint: NetworkEndpoint) -> Single<Model> where Model: Decodable {
        return request(endpoint: endpoint)
            .map { [decoder] data in
                do { return try decoder.decode(Model.self, from: data) } catch {
                    //                    throw AppError.jsonMapping(error)
                    throw error
                }
            }.debug("[requestModel] [\(endpoint.path)]")
    }
    
    private func target(endpoint: NetworkEndpoint) -> MoyaTarget {
        MoyaTarget(
            baseURL: baseUrl,
            path: endpoint.path,
            method: endpoint.method.toMoyaMethod(),
            task: endpoint.task?.toMoyaTask() ?? Task.requestPlain,
            headers: defaultHeaders(),
            authorizationType: endpoint.isAuthorizationRequired ? .basic : nil
        )
    }
    
    private func defaultHeaders(
        bundle: Bundle = .main,
        device: UIDevice = .current,
        locale: Locale = .current
    ) -> [String: String] {
        var result = [String: String]()
        
        let dictionary = bundle.infoDictionary
        result["x-version-name"] = dictionary?["CFBundleShortVersionString"] as? String
        result["x-version-code"] = dictionary?["CFBundleVersion"] as? String
        result["x-package"] = dictionary?["CFBundleIdentifier"] as? String
        result["x-bundle-name"] = dictionary?["CFBundleName"] as? String
        result["x-system"] = "iOS\(device.systemVersion)"
        result["device-id"] = device.identifierForVendor?.uuidString ?? "n/a"
        result["x-device"] = "iOS"
        result["x-device-language"] = locale.identifier.replacingOccurrences(of: "_", with: "-")
        
        return result
    }
}


extension MoyaApiClient: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.cancelAuthenticationChallenge, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

private struct MoyaTarget: TargetType, AccessTokenAuthorizable {
    let baseURL: URL
    let path: String
    let method: Moya.Method
    let sampleData: Data = Data()
    let task: Task
    let headers: [String: String]?
    let authorizationType: AuthorizationType?
}


private extension NetworkEndpoint.Method {
    func toMoyaMethod() -> Moya.Method {
        switch self {
        case .delete:
            return .delete
        case .get:
            return .get
        case .post:
            return .post
        case .path:
            return .patch
        case .put:
            return .put
        }
    }
}

private extension NetworkEndpoint.Task {
    func toMoyaTask() -> Moya.Task {
        switch self {
        case let .formData(fields):
            return .requestParameters(parameters: fields.compactMapValues({ $0 }), encoding: URLEncoding.httpBody)
        case let .json(fields):
            return .requestParameters(parameters: fields.compactMapValues({ $0 }), encoding: JSONEncoding.default)
        case let .query(params):
            return .requestParameters(parameters: params.compactMapValues({ $0 }), encoding: URLEncoding.queryString)
        }
    }
}

struct BasicAuthPlugin: PluginType {
    let username: String?
    let password: String?
    
    //    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    //        var request = request
    //        if let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() {
    //            let authValue = "Basic \(credentials)"
    //            request.addValue(authValue, forHTTPHeaderField: "Authorization")
    //        }
    //        return request
    //    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let target = target as? MoyaTarget, target.authorizationType == .basic else {
            return request
        }
        var request = request
        guard let username, let password else {
            return request
        }
        
        if let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() {
            let authValue = "Basic \(credentials)"
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
        }
        //            if let credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() {
        //                let authValue = "Basic \(credentials)"
        //                request.addValue(authValue, forHTTPHeaderField: "Authorization")
        //            }
        return request
    }
}
