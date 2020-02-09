//
//  ApiManager.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/9.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Foundation
import Moya
import RxSwift

final class ApiManager {
    
    static let shared = ApiManager()
    
    //private let provider = MoyaProvider<GitHubApiManager>(plugins: [NetworkLoggerPlugin(verbose: true)])
    private let provider = MoyaProvider<MultiTarget>()
    
    func request<Request: ResponseTargetType>(_ request: Request) -> Single<Response> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target).filterSuccessfulStatusCodes()
    }
    
    func requestReturnDecodable<Request: DecodableResponseTargetType>(_ request: Request) -> Single<Request.ResponseType> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target).filterSuccessfulStatusCodes().map(Request.ResponseType.self)
    }
}

protocol ResponseTargetType: TargetType {
    
    var parameters: [String: Any]? { get }
}

extension ResponseTargetType {
    
    var task: Task {
        if parameters == nil {
            return .requestPlain
        } else {
            switch method {
            case .get:
                return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
            case .post:
                // Json格式
                return .requestParameters(parameters: parameters ?? [:], encoding: JSONEncoding.default)
            default:
                return .requestPlain
            }
        }
    }
}

protocol DecodableResponseTargetType: ResponseTargetType {
    
    associatedtype ResponseType: Decodable
}
