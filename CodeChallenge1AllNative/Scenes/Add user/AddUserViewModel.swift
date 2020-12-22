//
//  AddUserViewModel.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 22/12/20.
//

import Foundation
import Combine
import CodeChallengeModel

class AddUserViewModel {
    
    enum Error: LocalizedError {
        case emptyName
        case emptyEmail
        case invalidEmail
        case none
        
        var errorDescription: String? {
            switch self {
            case .emptyName: return "Name cannot be empty"
            case .emptyEmail: return "Email cannot be empty"
            case .invalidEmail: return "Malformed Email"
            case .none: return nil
            }
        }
    }
    
    let responder: AddUserResponder
    
    @Published var name: String = ""
    @Published var email: String = ""
    var gender: User.Gender = .female
    var status: User.Status = .inactive
    @Published private(set) var doneEnabled: Bool = false
    @Published private var error: AddUserViewModel.Error = .none
    var errorPublisher: AnyPublisher<String?, Never> {
        $error.map{$0.errorDescription}.eraseToAnyPublisher()
    }    
    
    init(responder: AddUserResponder) {
        self.responder = responder

        $name.combineLatest($email)
            .map { name, email -> AddUserViewModel.Error in
                
                if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return .emptyName
                }
                
                if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return .emptyEmail
                }

                if !email.isEmail {
                    return .invalidEmail
                }
                
                return .none
            }
            .assign(to: &$error)
            
        $error.map{$0 == .none ? true : false}
            .assign(to: &$doneEnabled)
    }
    
    @objc func doneAction() {
        responder.created(user: User(name: name,
                                     email: email,
                                     gender: gender,
                                     status: status,
                                     createdOn: Date()))
    }
    
    @objc func cancelAction() {
        responder.canceled()
    }
}

protocol AddUserResponder {
    func canceled()
    func created(user: User)
}
