//
//  User.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

public struct User {
    var id: String
    var email: String
    var name: String
    var gender: Gender
    var status: Status
    var lastUpdated: Date
}

extension User {

    public enum Gender: String {
        case male = "Male"
        case female = "Female"
    }
    
    public enum Status: String {
        case active = "Active"
        case inactive = "Inactive"
    }

    public enum SortableField {
        case name
        case id
        case lastUpdated
    }
}

extension User {
    static func sorter(_ user1: User, _ user2: User, by field: SortableField) -> Bool{
        switch field {
        case .name: return user1.name > user2.name
        case .id: return user1.id > user2.id
        case .lastUpdated: return user1.lastUpdated > user2.lastUpdated
        }
    }
}
