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
    
    enum OperationState {
        case dormant
        case requested
        case inprogress
        case completed(errorMessage: String?)
    }
    
    enum Error: LocalizedError {
        //for UI
        
    }
    
    private let repository: UserRepository
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private(set) var users: [User] = []
    @Published var fetchMoreTask: OperationState = .dormant {
        didSet {
            if case .requested = fetchMoreTask {
                fetchMore()
            }
        }
    }
    
    init(repository: UserRepository = repo) {
        self.repository = repository
        repository.users.assign(to: &$users)
    }
}

extension UserListViewModel {
    
    func delete(user: User) -> AnyPublisher<Void, APIError.User> {
        repository.delete(user: user)
    }
    
    func sort(field: User.SortableField) {
        repository.sort(by: field)
    }
}

extension UserListViewModel {
    
    private func fetchMore() {
        if case .inprogress = fetchMoreTask {return}
        fetchMoreTask = .inprogress
        
        repository.getMore()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: self?.fetchMoreTask = .completed(errorMessage: nil)
                case .failure(let error): self?.fetchMoreTask = .completed(errorMessage: error.localizedDescription)
                }
            }, receiveValue:{})
            .store(in: &subscriptions)
    }
}
