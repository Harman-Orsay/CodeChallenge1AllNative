//
//  UserRepository.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine

public protocol UserRepository {
    
    var users: AnyPublisher<[User], Never> {get}
    
    func add(user: User) -> AnyPublisher<Void, User.Error>
    func delete(user: User) -> AnyPublisher<Void, User.Error> 
    func getMore() -> AnyPublisher<Void, User.Error>
    func sort(by field: User.SortableField)
}
