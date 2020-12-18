//
//  UserDTO.swift
//  CodeChallenge1BL
//
//  Created by Rohan Ramsay on 8/12/20.
//

import Foundation

struct UserDTO: Codable { // for GET & POST
    let id: Int?
    let createdAt: String?
    let updatedAt: String?
    let email: String
    let gender: String
    let name: String
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case gender
        case name
        case status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension UserDTO {
    var createdAtDate: Date? {
        createdAt?.toDate(dateFormatter: Self.dateFormatter)
    }
    
    var updatedAtDate: Date? {
        updatedAt?.toDate(dateFormatter: Self.dateFormatter)
    }
    
    static var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = NetworkConstant.responseDateFormat
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.locale = Locale(identifier: "en_US_POSIX")
        return df
    }()
}

extension UserDTO {
    init(from user: User, forNewUser: Bool = false) {
        self.init(id: forNewUser ? nil : user.id,
                  createdAt: forNewUser ? nil :  user.lastUpdated.toString(),
                  updatedAt: forNewUser ? nil :  user.lastUpdated.toString(),
                  email: user.email,
                  gender: user.gender.rawValue,
                  name: user.name,
                  status: user.status.rawValue)
    }
}
