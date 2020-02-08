//
//  NSObject+Ext.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/8.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Foundation

extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

extension BaseViewModel {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
