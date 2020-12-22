//
//  User+DTO.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

extension User {
    init(dto: UserDTO) {
        self.init(id: dto.id ?? -1,
                  name: dto.name,
                  email: dto.email,
                  gender: Gender(rawValue: dto.gender) ?? .female,
                  status: Status(rawValue: dto.status) ?? .inactive,
                  lastUpdated: dto.updatedAtDate ?? dto.createdAtDate ?? Date())
    }
}
