//
//  UserService+Endpoint.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

extension UserRestfulService.Endpoint: Endpoint {
    
    var baseUrl: String {
        NetworkConstant.serverURL + "public-api/users"
    }
    
    var path: String {
        switch self{
        case .delete(let id): return "/\(id)"
        case .fetch(_), .create(_) : return ""
        }
    }
    
    var parameters: [ParameterType] {
        switch self {
        case .fetch(let page): return page != nil ? [.url(name: "page", value: "\(page!)")] : []
        case .create(let user): return [.json(value: try? JSONEncoder().encode(user))]
        case .delete(_) : return []
        }
    }
    
    var headers: HTTPHeaders {
        var headers = ["Accept" : "application/json",
                       "Content-Type" : "application/json"]
        switch self {
        case .fetch(_): break
        case .create(_), .delete(_): headers["Authorization"] = "Bearer" + " " + NetworkConstant.accessToken
        }
        return headers
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetch(_): return .get
        case .create(_): return .post
        case .delete(_): return .delete
        }
    }
}
