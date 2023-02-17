//
//  UserResponse.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct UserResponse: Codable{
    let id: Int
    let email, password, userName, birth: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email, password, userName = "username", birth
    }
}
