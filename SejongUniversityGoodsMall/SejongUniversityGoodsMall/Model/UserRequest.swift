//
//  User.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct UserRequest: Codable {
    let email, password, username, birth: String
}
