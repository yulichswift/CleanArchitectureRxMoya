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
    
    private let rightBtn = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: nil)
    
    private var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setupNavigationBar()
        setupTableView()
        setupViewModel()
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
            .throttle(1, scheduler: SerialDispatchQueueScheduler(qos: .background))
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
        
        // MARK: Obserable transtrome
        let viewWillAppear = rx
            .sentMessage(#selector(MainViewController.viewWillAppear(_:)))
            .mapToVoid()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged).mapToVoid()
        
        let tap = rightBtn.rx.tap.mapToVoid()
        
        // latest: 最後一筆是否送出
        let mergeObservable = Observable.merge(viewWillAppear, pull, tap)
        
        let output = viewModel.transform(input: MainViewModel.Input(fetchUsers: mergeObservable))
        
        output.resultUsers
            .asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: "FirstCell", cellType: SampleTableViewCell.self)) { (index, model, cell) in
                cell.setModel(model)
                cell.delegate = self
        }
        .disposed(by: disposeBag)
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightBtn
    }
    
    private func setupTableView() {
        tableView.delegate = self
        //tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
    }
    
    private func presentDetailView(_ model: GitHubUserElement) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            let nextVM = DetailViewModel()
            nextVM.titleBehavior.onNext("\(model.id) \(model.login)")
            nextVM.urlBehavior.onNext(model.url)
            nextVM.avatarUrlBehavior.onNext(model.avatarURL)
            nextVC.bind(nextVM)
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? SampleTableViewCell {
            if let data = cell.data {
                presentDetailView(data)
            }
        }
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

extension MainViewController: SampleTableViewCellAction {
    func onClickedBtn(id: Int) {
        print("Id: \(id)")
    }
}
