//
//  MainViewModel.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/4.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

final class MainViewModel: BaseViewModel {
        
    let apiManager = ApiManager.shared
    
    var since = 8
}

extension MainViewModel: ObserableTransform {
    
    struct Input {
        let fetchUsers: Observable<Void>
    }
    
    struct Output {
        let resultUsers: Driver<GitHubUsers>
    }
    
    func transform(input: Input) -> Output {
        
        let resultUsers = input.fetchUsers
            .throttle(10, latest: false, scheduler: SerialDispatchQueueScheduler(qos: .background))
            .flatMap {
                return self.apiManager.requestReturnDecodable(GitHubApi.GetUsers(since: self.since))
                    .do(onSuccess: { _ in
                        logger.verbose("Load onSuccess")
                        self.progressingPublish.onNext(false)
                    }, onError: { _ in
                        logger.verbose("Load onError")
                        self.progressingPublish.onNext(false)
                    }, onSubscribe: {
                        logger.verbose("Loading")
                        self.progressingPublish.onNext(true)
                    })
                    .catchError { error in
                        logger.error(error)
                        return Single.just([])
                }
        }
        .asDriver(onErrorJustReturn: []) // driver觀察時, 會轉換成main thread.
        
        return Output(resultUsers: resultUsers)
    }
}
