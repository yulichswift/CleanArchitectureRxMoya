//
//  PublishViewController.swift
//  CleanArchitectureRxMoya
//
//  Created by Jeff Yu on 2020/2/7.
//  Copyright © 2020 Jeff. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

class PublishViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let rightBtn = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: nil)
    
    private var viewModel: PublishViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setupNavigationBar()
        setupTableView()
        setupViewModel()
        setupObserver()
    }
    
    private func setupViewModel() {
        viewModel = PublishViewModel()
        
        viewModel.progressingPublish
            .throttle(2.5, scheduler: SerialDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe({ event in
                if (true == event.element) {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                } else {
                    self.tableView.refreshControl?.endRefreshing()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        // TableView方法1 (drive)
        viewModel.usersPublish
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "FirstCell", cellType: SampleTableViewCell.self)) { (index, data, cell) in
                cell.setData(data)
        }
        .disposed(by: disposeBag)
        
        // TableView方法2 (bind)
        // https://github.com/RxSwiftCommunity/RxDataSources
        /*
         viewModel.usersPublish
         .bind(to: tableView.rx.items(cellIdentifier: "FirstCell", cellType: SampleTableViewCell.self)) { index, model, cell in
         cell.setModel(model)
         }
         .disposed(by: disposeBag)
         */
    }
    
    private func setupObserver() {
        let viewWillAppear = rx
            .sentMessage(#selector(MainViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let rightBtnTap = rightBtn.rx.tap.asDriver()
        
        Driver.merge(viewWillAppear, pull, rightBtnTap)
            .throttle(1, latest: false) // latest: 最後一筆是否送出
            .drive(onNext: {
                logger.verbose("Load data")
                self.viewModel.fetchUsersSince(10)
            }).disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightBtn
    }
    
    private func setupTableView() {
        //tableView.delegate = self
        //tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
    }
}
