//
//  DetailViewModel.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/6.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

final class DetailViewModel: BaseViewModel {
    
    let titleBehavior: BehaviorSubject<String> = BehaviorSubject.init(value: "")
    let urlBehavior: BehaviorSubject<String> = BehaviorSubject.init(value: "")
    let avatarUrlBehavior: BehaviorSubject<String> = BehaviorSubject.init(value: "")
}

extension DetailViewModel: ObserableTransform {

    struct Input {
        let enterText: Driver<String>
    }
    
    struct Output {
        let enterVaild: Driver<Bool>
    }

    func transform(input: Input) -> Output {
        
        let enterVaild = input.enterText
            .map { text in
            text.count < 3
        }
        
        return Output(enterVaild: enterVaild)
    }
}
