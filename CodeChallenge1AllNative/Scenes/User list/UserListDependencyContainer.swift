//
//  UserListDependencyContainer.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 21/12/20.
//

import Foundation
import UIKit
import CodeChallengeModel

class UserListDependencyContainer {
    
    private let dataDependencyFactory = UserDataDependencyFactory()
    
    func makeUserListViewModel() -> UserListViewModel {
        UserListViewModel(repository: dataDependencyFactory.makeRepository())
    }
    
    func makeUserListViewControllerFactory() -> UserListViewControllerFactory {
        self
    }
    
    func makeAddUserViewModel(responder: AddUserResponder) -> AddUserViewModel {
        AddUserViewModel(responder: responder)
    }
}

extension UserListDependencyContainer: UserListViewControllerFactory {
    func makeAddUserNavigationController(responder: AddUserResponder) -> UINavigationController {
        let navC = UIStoryboard(name: "AddUser", bundle: nil).instantiateViewController(withIdentifier: "AddUserNavC") as! UINavigationController
        let vc = navC.viewControllers.first as! AddUserViewController
        vc.viewModel = makeAddUserViewModel(responder: responder)
        return navC
    }
}

protocol UserListViewControllerFactory {
    func makeAddUserNavigationController(responder: AddUserResponder) -> UINavigationController
}
