//
//  SortFieldsTableViewController.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 22/12/20.
//

import UIKit
import Combine

class SortFieldsTableViewController: UITableViewController {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    var viewModel: SortFieldsViewModel!
    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
    }
    
    func setupBindings() {
        
        doneBarButton.target = viewModel
        doneBarButton.action = #selector(SortFieldsViewModel.doneAction)
        
        viewModel.$selectedField
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [unowned self] _ in
                tableView.reloadData()
            })
            .store(in: &subscriptions)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fields.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let field = viewModel.fields[indexPath.row]
        cell.textLabel?.text = field.rawValue
        cell.accessoryType = field == viewModel.selectedField ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedField = viewModel.fields[indexPath.row]
    }
}
