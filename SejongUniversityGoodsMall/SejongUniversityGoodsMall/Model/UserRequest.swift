//
//  User.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct UserRequest: Codable {
    var email, password, userName, birth: String
    
    enum CodingKeys: String, CodingKey {
        case email, password, userName = "username", birth
    }
}
