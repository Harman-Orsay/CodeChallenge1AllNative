//
//  TabBarViewController.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 21/12/20.
//

import UIKit

class TabBarViewController: UITabBarController {

    var injectionContainer: AppDependencyContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let userListVC = (viewControllers?.first as? UINavigationController)?.viewControllers.first as? UserListViewController {
            userListVC.viewModel = injectionContainer.userList.makeUserListViewModel()
            userListVC.viewControllerFactory = injectionContainer.userList.makeUserListViewControllerFactory()
        }
    }
}
