//
//  MockUserServiceEndpoint.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 25/12/20.
//

import Foundation

enum StubUserServiceEndpoint {
    case createUser
    case deleteUser
    case fetchUsers
    
    var urlRequest: URLRequest {
        switch self {
        
        case .createUser:
            var req = URLRequest(url: URL(string: "https://gorest.co.in/public-api/users")!)
            req.httpMethod = "POST"
            req.httpBody = payload
            return req
            
        case .deleteUser:
            var req = URLRequest(url: URL(string: "https://gorest.co.in/public-api/users/1")!)
            req.httpMethod = "DELETE"
            return req

            
        case .fetchUsers:
            var req = URLRequest(url: URL(string: "https://gorest.co.in/public-api/users?page=3")!)
            req.httpMethod = "GET"
            return req
        }
    }
    
    var payload: Data? {
        
        switch self {
        case .createUser: return File.getData(name: "CreateUserPayload", withExtension: "json")
        case .deleteUser: return nil
        case .fetchUsers: return nil
        }

    }
}

 
