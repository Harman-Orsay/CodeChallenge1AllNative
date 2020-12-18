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
    
    func add(user: User) -> AnyPublisher<Void, APIError.User>
    func delete(user: User) -> AnyPublisher<Void, APIError.User>
    func getMore() -> AnyPublisher<Void, APIError.User>
    func sort(by field: User.SortableField)
}
