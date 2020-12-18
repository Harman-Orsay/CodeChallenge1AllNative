//
//  UsersReponseDTO.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

struct UserReponseErrorDTO: Decodable {
    var code: Int
    var data: [ErrorDTO]
    
    struct ErrorDTO: Decodable {
        var field: String?
        var message: String?
    }
    
    var error: APIError.User {
        var errorMessage = ""
        
        if let field = data.first?.field {
            errorMessage = field + "\n"
        }
        
        if let message = data.first?.message {
            errorMessage += message
        }
        
        return .server(message: errorMessage)
    }
}
