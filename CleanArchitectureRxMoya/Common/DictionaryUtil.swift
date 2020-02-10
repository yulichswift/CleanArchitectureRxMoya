//
//  DictionaryUtil.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/10.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Foundation

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension Dictionary {
    func asDecodable<T>(_ type: T.Type) throws -> T where T: Decodable {
        let data = try JSONSerialization.data(withJSONObject: self, options: [])
        return try JSONDecoder().decode(type, from: data)
    }
}
