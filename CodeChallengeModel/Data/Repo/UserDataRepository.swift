//
//  UserDataRepository.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine

public let repo: UserRepository = UserDataRepository()

class UserDataRepository {
    
    private var userPool: CurrentValueSubject<[User], Never>
    private var service: UserService
    
    private(set) public var sortField: User.SortableField = .id {
        didSet {
            userPool.send(userPool.value)
        }
    }

    init(service: UserService = UserRestfulService()) {
        self.service = service
        self.userPool = CurrentValueSubject<[User], Never>([])
    }
}

extension UserDataRepository: UserRepository {

    var users: AnyPublisher<[User], Never> {
        userPool
            .map{ $0.sorted{ User.sorter($0, $1, by: self.sortField) }}
            .eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<Void, APIError.User> {
        service.add(user: user)
            .handleEvents(receiveOutput: {self.userPool.value += [$0]})
            .map{_ in}
            .eraseToAnyPublisher()
    }
    
    func delete(user: User) -> AnyPublisher<Void, APIError.User> {
        service.delete(user: user)
            .handleEvents(receiveOutput: {self.userPool.value.removeAll{$0.id == user.id}})
            .map{_ in}
            .eraseToAnyPublisher()
    }
    
    func getMore() -> AnyPublisher<Void, APIError.User> {
        service.fetchNextPage()
            .handleEvents(receiveOutput: {self.userPool.value += $0})
            .map{_ in}
            .eraseToAnyPublisher()
    }
    
    func sort(by field: User.SortableField) {
        sortField = field
    }
}
