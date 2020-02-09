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

/**
 https://qiita.com/kouheiszk/items/46e9a233d9bb227c3b1d
 
 https://medium.com/@davidlin_98861/%E8%8F%AF%E9%BA%97%E7%9A%84-network-layer-c5c664dcca47
 */

protocol GitHubApiTargetType: DecodableResponseTargetType { }

extension GitHubApiTargetType {
    
    var baseURL: URL {
        #if DEBUG
        return URL(string: "https://api.github.com")!
        #else
        return URL(string: "https://api.github.com")!
        #endif
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var sampleData: Data {
        let path = Bundle.main.path(forResource: "samples", ofType: "json")!
        return FileHandle(forReadingAtPath: path)!.readDataToEndOfFile()
    }
}

enum GitHubApi {
    
    struct GetUsers: GitHubApiTargetType {
        
        let since: Int
        
        init(since: Int) {
            self.since = since
        }
        
        var method: Moya.Method { return .get }
        
        var path = "/users"
        
        var parameters: [String: Any]? {
            return ["since" : since]
        }
        
        typealias ResponseType = GitHubUsers
    }
}
