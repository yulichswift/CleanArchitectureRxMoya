//
//  GitHubApi.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/1/31.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum GitHubApi {
    case allUsers(since: Int)
}

extension GitHubApi: TargetType {
    
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL {
        #if DEBUG
        return URL(string: "https://api.github.com")!
        #else
        return URL(string: "https://api.github.com")!
        #endif
    }
    
    var path: String {
        switch self {
        case .allUsers:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .allUsers:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .allUsers(let since):
            return ["since" : since]
        }
    }
    
    var sampleData: Data {
        switch self {
        default :
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        // 無參數
        //return .requestPlain
        
        // Post Json格式
        //return .requestParameters(parameters: parameters ?? [:], encoding: JSONEncoding.default)
        
        switch self {
        case .allUsers:
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
        }
    }
}
