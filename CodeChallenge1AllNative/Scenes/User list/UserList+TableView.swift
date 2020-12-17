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
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension UserListViewController: UITableViewDelegate {
    
}

