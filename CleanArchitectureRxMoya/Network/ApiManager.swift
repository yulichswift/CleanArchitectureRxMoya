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
    
    func request<Request: TargetType>(_ request: Request) -> Single<Response> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target).filterSuccessfulStatusCodes()
    }
}

protocol DecodableResponseTargetType: TargetType {
    var responseType: Decodable { get }
}
