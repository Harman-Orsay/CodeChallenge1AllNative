//
//  UserService.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine

protocol UserService {
    
    func fetchNextPage() -> AnyPublisher<[User], APIError.User>
    func delete(user: User) -> AnyPublisher<Void, APIError.User>
    func add(user: User) -> AnyPublisher<User, APIError.User>
}

//Service can be implemented via rest, graphql etc.
