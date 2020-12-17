//
//  UserService.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine

protocol UserService {
    
    func fetchNextPage() -> AnyPublisher<[User], User.Error>
    func delete(user: User) -> AnyPublisher<Void, User.Error>
    func add(user: User) -> AnyPublisher<User, User.Error>
}

//Service can be implemented via rest, graphql etc.
