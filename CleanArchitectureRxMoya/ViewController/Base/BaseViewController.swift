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
    
    deinit {
        // 測試物件釋放
        logger.verbose(self.theClassName)
    }

    fileprivate var _disposeBag: DisposeBag?
    
    var disposeBag: DisposeBag {
        get {
            if (_disposeBag == nil) {
                _disposeBag = DisposeBag()
            }
            
            return _disposeBag!
        }
    }
    
    func clearDisposeBag() {
        _disposeBag = nil
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logger.verbose(self.theClassName)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        logger.verbose(self.theClassName)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if (self.navigationController == nil) {
            logger.verbose("View release")
            clearDisposeBag()
        } else {
            logger.verbose("View keep")
        }
    }
}
