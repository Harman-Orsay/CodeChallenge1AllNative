//
//  User+DTO.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

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

extension User {
    init(dto: UserDTO) {
        self.init(id: dto.id ?? "",
                  email: dto.email,
                  name: dto.name,
                  gender: Gender(rawValue: dto.gender) ?? .female,
                  status: Status(rawValue: dto.status) ?? .inactive,
                  lastUpdated: dto.updatedAtDate ?? dto.createdAtDate ?? Date())
    }
}
