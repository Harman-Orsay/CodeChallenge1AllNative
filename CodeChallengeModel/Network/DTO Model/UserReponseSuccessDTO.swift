//
//  UserReponseSuccessDTO.swift
//  CodeChallengeModel
//
//  Created by Rohan Ramsay on 17/12/20.
//

import Foundation

struct UserFetchResponseSuccessDTO: Decodable {
    let data: [UserDTO]
}

struct UserCreateReponseSuccessDTO: Decodable {
    let data: UserDTO
}

struct UserDeleteReponseSuccessDTO: Decodable {
    let code: Int
}
