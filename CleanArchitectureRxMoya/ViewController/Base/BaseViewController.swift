//
//  BaseViewController.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/5.
//  Copyright © 2020 Jeff. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class BaseViewController: UIViewController {

    var disposeBag = DisposeBag()
    
    func clearDisposeBag() {
        disposeBag = DisposeBag()
    }
}
