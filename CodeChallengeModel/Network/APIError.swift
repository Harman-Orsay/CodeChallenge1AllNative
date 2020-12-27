//
//  User+Error.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

public enum APIError { //namespace for ALL errors
    
    public enum User: Error { //server is sending detailed errors so no need to have specific error cases here
        case network
        case server(message: String)
        
        public var localizedDescription: String {
            switch self {
            case .network: return "Something went wrong. Check your Internet connection and try again."
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
 
 model is the core business entity - it must not be aware of such errors?
 - only being used for its namespace, the errors are part of business?
 
 External enum? YES
 */
