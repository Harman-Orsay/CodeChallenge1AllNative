//
//  UserList+TableView.swift
//  CodeChallenge1
//
//  Created by Rohan Ramsay on 8/12/20.
//  Copyright © 2020 Harman Orsay. All rights reserved.
//

import UIKit

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.users[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(user.id)" + ": " + user.name
        return cell
    }    
}

extension UserListViewController: UITableViewDelegate {
    
}

extension UserListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.hasScrolledToBottom() {
            viewModel.fetchMoreTask = .requested
        }
    }
}
