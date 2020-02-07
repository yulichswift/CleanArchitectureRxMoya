//
//  BaseViewModel.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/5.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

/**
 https://github.com/Moya/Moya/blob/master/docs/Plugins.md
 
 https://qiita.com/kouheiszk/items/46e9a233d9bb227c3b1d
 
 https://github.com/onevcat/Kingfisher
 */

open class BaseViewModel {
    
    deinit {
        // 測試物件釋放
        print("Deinit: \(self)")
    }
    
    let progressingPublish: PublishSubject<Bool> = PublishSubject.init()
}
