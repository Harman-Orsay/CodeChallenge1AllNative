//
//  MockUserRepository.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 28/12/20.
//

import Foundation
import Combine

//For unit testing - viewmodel, view controlers & UI tests

class MockUserRepository: UserRepository {
    
    var users: AnyPublisher<[User], Never> {
        userPool.eraseToAnyPublisher()
    }
    
    var userPool = CurrentValueSubject<[User], Never>([])
    
    var nextOperationError: APIError.User? = nil
    func tearDown() {
        nextOperationError = nil
    }
    
    func add(user: User) -> AnyPublisher<Void, APIError.User> {
        if let error = nextOperationError {
                return Fail(outputType: Void.self, failure: error)
                    .eraseToAnyPublisher()
        }
        
        userPool.value += [user]
        
        return Just(()).mapError{_ -> APIError.User in}
            .eraseToAnyPublisher()
    }
    
    func delete(user: User) -> AnyPublisher<Void, APIError.User> {
        if let error = nextOperationError {
                return Fail(outputType: Void.self, failure: error)
                    .eraseToAnyPublisher()
        }
        
        userPool.value.removeAll{$0.id == user.id}
        return Just(()).mapError{_ -> APIError.User in}
            .eraseToAnyPublisher()
    }
    
    func getMore() -> AnyPublisher<Void, APIError.User> {
        if let error = nextOperationError {
                return Fail(outputType: Void.self, failure: error)
                    .eraseToAnyPublisher()
        }
        
        let userDtos = try! JSONDecoder().decode(UserFetchResponseSuccessDTO.self,
                                                  from: File.getData(name: "FetchUsersSuccessResponse"))
            .data
       
        userPool.value = userDtos.map{User(dto: $0)}
        
        return Just(()).mapError{_ -> APIError.User in}
            .eraseToAnyPublisher()
    }
    
    func sort(by field: User.SortableField) {
        userPool.value = userPool.value.sorted(by: { User.sorter($0, $1, by: field) })
    }
}
