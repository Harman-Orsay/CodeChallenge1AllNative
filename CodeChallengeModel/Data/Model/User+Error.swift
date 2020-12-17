//
//  User+Error.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

extension User {
    
    public enum Error: LocalizedError {
        
        case network
        case server(message: String)
        
        public var errorDescription: String? {
            switch self {
            case .network: return "Something went wrong.\n\nCheck your Internet connection and try again."
            case .server(let message): return message
            }
        }
    }
}

/*
 Where to put Business-Specific errors?
 (ie declare the error enum)
 
 service / API - then they cannot be accessed as protocol - close-coupling to repo
 repository - then repo cannot be accessed as protocol - close coupling to viewmodel / presenter
 
 model - YES?
 - model is the only concrete type exposed across all protocols
 */
