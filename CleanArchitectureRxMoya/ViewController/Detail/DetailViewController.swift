//
//  DetailViewController.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/6.
//  Copyright © 2020 Jeff. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class DetailViewController: BaseViewController {
    
    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var labelUrl: UILabel!
    @IBOutlet weak var tvInput: UITextField!
    
    private var viewModel: DetailViewModel!
    
    func bind(_ viewModel: DetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        
        viewModel.titleBehavior
            .subscribe(onNext:{ title in
                self.navigationItem.title = title
            })
            .disposed(by: disposeBag)
        
        viewModel.urlBehavior
            .subscribe(onNext:{ title in
                self.labelUrl.text = title
            })
            .disposed(by: disposeBag)
        
        viewModel.avatarUrlBehavior
            .subscribe(onNext: { url in
                let processor = RoundCornerImageProcessor(cornerRadius: 20)
                
                self.ivAvatar.kf.setImage(with: URL(string: url),
                                          options: [.processor(processor)])
            })
            .disposed(by: disposeBag)
        
        let input = DetailViewModel.Input(enterText: tvInput.rx.text.orEmpty.asDriver())
        let output = viewModel.transform(input: input)
        
        output.enterVaild
            .asObservable()
            .subscribe(onNext: { isValid in
                self.tvInput.textColor = true == isValid ? UIColor.red : UIColor.black
            })
            .disposed(by: disposeBag)
    }
}
