//
//  UserResponse.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct UserResponse: Codable {
    let id: Int
    let email, password, username, birth: String
}
