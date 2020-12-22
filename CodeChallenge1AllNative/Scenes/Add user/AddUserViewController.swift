//
//  AddUserViewController.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 22/12/20.
//

import UIKit
import Combine

class AddUserViewController: UIViewController {

    var viewModel: AddUserViewModel!
    var subscriptions = Set<AnyCancellable>()

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var statusSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
    }
    
    func bindToViewModel() {
        
        cancelBarButton.target = viewModel
        cancelBarButton.action = #selector(AddUserViewModel.cancelAction)
        
        doneBarButton.target = viewModel
        doneBarButton.action = #selector(AddUserViewModel.doneAction)
        
        nameTextfield
            .liveTextPublisher
            .assign(to: \.name, on: viewModel)
            .store(in: &subscriptions)
        
        emailTextfield
            .liveTextPublisher
            .assign(to: \.email, on: viewModel)
            .store(in: &subscriptions)

        viewModel.$doneEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: doneBarButton)
            .store(in: &subscriptions)
        
        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: errorLabel)
            .store(in: &subscriptions)
    }
}
