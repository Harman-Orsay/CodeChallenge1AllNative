//
//  MockUserService.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 25/12/20.
//

import Foundation
import Combine
@testable import CodeChallengeModel

class MockUserService: UserService {
    
    var failNextWithError: APIError.User? = nil
    func tearDown() {
        failNextWithError = nil
    }
    
    func fetchNextPage() -> AnyPublisher<[User], APIError.User> {
        if let error = failNextWithError {
            return Fail(outputType: [User].self, failure: error)
                .eraseToAnyPublisher()
        }
        
        
        let userDtos = try! JSONDecoder().decode(UserFetchResponseSuccessDTO.self,
                                                  from: File.getData(name: "FetchUsersSuccessResponse"))
            .data
       
        let users = userDtos.map{User(dto: $0)}
        return Just(users)
            .mapError{_ -> APIError.User in}
            .eraseToAnyPublisher()
    }
    
    func delete(user: User) -> AnyPublisher<Void, APIError.User> {
        if let error = failNextWithError {
            return Fail(outputType: Void.self, failure: error)
                .eraseToAnyPublisher()
        }
        return Just(())
            .mapError{_ -> APIError.User in}
            .eraseToAnyPublisher()
    }
    
    func add(user: User) -> AnyPublisher<User, APIError.User> {
        if let error = failNextWithError {
            return Fail(outputType: User.self, failure: error)
                .eraseToAnyPublisher()
        }
        let userDto = try! JSONDecoder().decode(UserCreateReponseSuccessDTO.self,
                                             from: File.getData(name: "CreateUserSuccessResponse"))
            .data
        let user = User(dto: userDto)
        return Just(user)
            .mapError{_ -> APIError.User in}
            .eraseToAnyPublisher()
    }
}
