//
//  ViewController.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/4.
//  Copyright © 2020 Jeff. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class MainViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let rightBtn = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: nil)
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setupNavigationbar()
        setupTableView()
        setupViewModel()
        setupObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        print("viewWillDisappear")
    }
    
    private func setupViewModel() {
        
        viewModel.progressingPublish
            .throttle(2.5, scheduler: SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                if (true == event.element) {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.usersPublish
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "FirstCell", cellType: SampleTableViewCell.self)) { (index, sample, cell) in
                cell.bind(data: sample)
        }
        .disposed(by: disposeBag)
    }
    
    private func setupObserver() {
        let viewWillAppear = rx.sentMessage(#selector(MainViewController.viewWillAppear(_:))).mapToVoid().asDriverOnErrorJustComplete()
        let rightBtnTap = rightBtn.rx.tap.asDriver()
        Driver.merge(viewWillAppear, rightBtnTap)
            .throttle(5, latest: false) // latest: 最後一筆是否送出
            .drive(onNext: {
                print("Load data")
                self.viewModel.fetchUsersSince(10)
            }).disposed(by: disposeBag)
    }
    
    private func setupNavigationbar() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightBtn
    }
    
    private func setupTableView() {
        tableView.delegate = self
        //tableView.dataSource = self
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

/*
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath)
        return cell
    }
}
*/
