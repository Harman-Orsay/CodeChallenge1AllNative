//
//  UserDataDependencyFactory.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 21/12/20.
//

import Foundation

public class UserDataDependencyFactory {
    
    public init(){}
    
    public func makeRepository() -> UserRepository {
        UserDataRepository(service: makeService())
    }
    
    private func makeService() -> UserService {
        UserRestfulService()
    }
}
