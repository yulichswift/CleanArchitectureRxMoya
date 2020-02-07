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
        
    //let provider = MoyaProvider<GitHubApiManager>(plugins: [NetworkLoggerPlugin(verbose: true)])
    let provider = MoyaProvider<GitHubApiManager>()
}

extension MainViewModel: ObserableTransform {
    
    struct Input {
        let fetchUsers: Observable<Void>
    }
    
    struct Output {
        let resultUsers: Observable<GitHubUsers>
    }
    
    func transform(input: Input) -> Output {
        
        let resultUsers = input.fetchUsers
            .throttle(10, latest: false, scheduler: SerialDispatchQueueScheduler(qos: .background))
            .flatMap {
                return self.provider.rx.request(.allUsers(since: 5))
                    .map(GitHubUsers.self)
                    .do(onSuccess: { _ in
                        print("Load onSuccess")
                        self.progressingPublish.onNext(false)
                    }, onError: { _ in
                        print("Load onError")
                        self.progressingPublish.onNext(false)
                    }, onSubscribe: {
                        print("Loading")
                        self.progressingPublish.onNext(true)
                    })
                    .catchError { error in
                        print("Error:", error)
                        return Single.just([])
                }
        }
        
        return Output(resultUsers: resultUsers)
    }
}