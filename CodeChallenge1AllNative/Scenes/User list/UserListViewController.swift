//
//  ViewController.swift
//  CodeChallenge1
//
//  Created by Rohan Ramsay on 21/10/20.
//  Copyright © 2020 Harman Orsay. All rights reserved.
//

import UIKit
import Combine

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var loadingFooter = LoadingIndicatorTableHeaderFooterView(frame: CGRect(origin: CGPoint.zero,
                                                                           size: CGSize(width: tableView.frame.width,
                                                                                        height: 44)))
    
    private var subscriptions = Set<AnyCancellable>()
    var viewModel = UserListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Users"
        
        setupTableView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchMoreTask = .requested
    }
}

extension UserListViewController {
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = loadingFooter
    }
    
    func setupBindings() {
        viewModel.$users
            .receive(on: RunLoop.main)
            .sink{ [unowned self] _ in
                tableView.reloadData()
            }
            .store(in: &subscriptions)
        
        viewModel.$fetchMoreTask
            .receive(on: RunLoop.main)
            .sink{ [unowned self] _ in
                switch viewModel.fetchMoreTask {
                case .dormant, .requested: return
                case .inprogress:
                    self.tableView.tableFooterView = self.loadingFooter
                    self.loadingFooter.state = .loading
                    self.tableView.scrollToBottom()

                case .completed(let errorMessage):
                    guard let message = errorMessage else {
                        self.tableView.tableFooterView = nil
                        return
                    }
                    self.loadingFooter.state = .completed(message: message)
                }
            }
            .store(in: &subscriptions)
    }
}

//@Published fires on willSet rather than didSet
//To receive the new value, need to push the execution to next run loop
//else you will always access the previous value inside sink
