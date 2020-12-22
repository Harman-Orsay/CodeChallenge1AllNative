//
//  UserListViewModel.swift
//  CodeChallenge1AllNative
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation
import Combine
import CodeChallengeModel


class UserListViewModel {
    
    enum Error: LocalizedError {
        //for UI
        
    }
    
    private let repository: UserRepository
    private var subscriptions = Set<AnyCancellable>()
    private var fetching: Bool = false
    
    @Published private(set) var users: [User] = []
    @Published private(set) var viewAction: UserListViewAction = .initial
    @Published private(set) var activityInprogress = false

    init(repository: UserRepository) {
        self.repository = repository
        repository.users.assign(to: &$users)
    }
}

extension UserListViewModel {

    func actionSort() {
        viewAction = .sort
    }
    
    func actionAdd() {
        viewAction = .add(self)
    }
    
    func actionList() {
        viewAction = .list
    }
}

extension UserListViewModel {
    
    func delete(user: User) -> AnyPublisher<Void, APIError.User> {
        activityInprogress = true
        return repository.delete(user: user)
            .handleEvents(receiveCompletion: {
                [weak self] _ in
                self?.activityInprogress = false
            })
            .eraseToAnyPublisher()
    }
    
    func fetchMore() -> AnyPublisher<Void, APIError.User> {
        guard !fetching else { return Just(())
            .mapError{_ in APIError.User.network}
            .eraseToAnyPublisher()
        }
        
        fetching = true
        return repository.getMore()
            .handleEvents(receiveCompletion: {[unowned self] _ in
                fetching = false
            })
            .eraseToAnyPublisher()
    }
    
    func sort(field: User.SortableField) {
        repository.sort(by: field)
    }
    
    func add(user: User) {
        activityInprogress = true
        repository.add(user: user)
            .sink(receiveCompletion: { [weak self]
                completion in
                self?.activityInprogress = false
//                switch completion {
//
//                case .finished:
//                    <#code#>
//                case .failure(_):
//                    <#code#>
//                }
            }, receiveValue: {})
            .store(in: &subscriptions)
    }
}

extension UserListViewModel: AddUserResponder {
    func canceled() {
        viewAction = .dismiss
    }
    
    func created(user: User) {
        viewAction = .dismiss
        add(user: user)
    }
}
