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
    
    private let repository: UserRepository
    private var subscriptions = Set<AnyCancellable>()
    private var fetching: Bool = false
    private var sortField: User.SortableField = .id {
        didSet {
            sort(field: sortField)
        }
    }

    @Published private(set) var users: [User] = []
    @Published private(set) var viewAction: UserListViewAction = .initial
    @Published private(set) var activityInprogress = false
    var errorPublisher = PassthroughSubject<(title: String?, message: String), Never>()

    init(repository: UserRepository) {
        self.repository = repository
        repository.users.assign(to: &$users)
    }
}

extension UserListViewModel {

    func actionSort() {
        viewAction = .sort(self, sortField)
    }
    
    func actionAdd() {
        viewAction = .add(self)
    }
    
    func actionList() {
        viewAction = .list
    }
}

extension UserListViewModel {
    
    func delete(user: User) {
        activityInprogress = true
        repository.delete(user: user)
            .sink(receiveCompletion: {
                [weak self] completion in
                self?.activityInprogress = false
                switch completion {
                case .finished: break
                case .failure(let error): self?.errorPublisher.send((title: "Could not delete user", message: error.localizedDescription))
                }
            }, receiveValue: {})
            .store(in: &subscriptions)
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
                switch completion {
                case .finished: break
                case .failure(let error):self?.errorPublisher.send((title: "Could not add user", message: error.localizedDescription))
                }
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

extension UserListViewModel: SortFieldSelectionResponder {
    func selected(field: User.SortableField) {
        viewAction = .dismiss
        if sortField != field {
            sortField = field
        }
    }
}
