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
    
    private func setupViewModel() {
        viewModel.progressingPublish
            .throttle(8, scheduler: MainScheduler.instance) // scheduler決定觀察時在什麼thread執行
            //.throttle(1, scheduler: SerialDispatchQueueScheduler(qos: .background))
            //.observeOn(MainScheduler.instance)
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
        
        let output = viewModel.transform(input: MainViewModel.Input(viewWillAppear: viewWillAppear, pullTableView: pull, tapRefreshBtn: tap))
        
        output.resultUsers
            .drive(tableView.rx.items(cellIdentifier: "FirstCell", cellType: SampleTableViewCell.self)) { (index, data, cell) in
                cell.setData(data)
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
    
    private func presentDetailView(isPresent: Bool, _ data: GitHubUserElement) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            let nextVM = DetailViewModel()
            nextVM.titleBehavior.onNext("\(data.id) \(data.login)")
            nextVM.urlBehavior.onNext(data.url)
            nextVM.avatarUrlBehavior.onNext(data.avatarURL)
            nextVC.bind(nextVM)
            
            if isPresent {
                // iOS13不會觸發"disappear"
                self.present(nextVC, animated: true, completion: nil)
            } else {
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
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
                presentDetailView(isPresent: true, data)
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
    func onClickedBtn(data: GitHubUserElement) {
        presentDetailView(isPresent: false, data)
    }
}
