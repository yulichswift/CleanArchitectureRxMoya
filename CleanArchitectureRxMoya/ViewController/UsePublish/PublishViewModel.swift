//
//  PublishViewModel.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/7.
//  Copyright © 2020 Jeff. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

final class PublishViewModel: BaseViewModel {
    
    let usersPublish: PublishSubject<GitHubUsers> = PublishSubject.init()
    
    let provider = MoyaProvider<GitHubApiManager>()
    
    var disposeBag = DisposeBag()
    
    func fetchUsersSince(_ since: Int) {
        progressingPublish.onNext(true)
        
        provider.rx.request(.allUsers(since: since))
            .subscribeOn(SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            //.mapString()
            .map(GitHubUsers.self)
            .subscribe { rusult in
                self.progressingPublish.onNext(false)
                
                switch rusult {
                case let .success(response):
                    //print(response) // Print string
                    self.usersPublish.onNext(response)
                case let .error(error):
                    print(error)
                    self.usersPublish.onNext([])
                }}.disposed(by: self.disposeBag)
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
