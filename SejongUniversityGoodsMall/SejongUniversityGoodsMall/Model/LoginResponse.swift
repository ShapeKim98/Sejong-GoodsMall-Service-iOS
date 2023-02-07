//
//  LoginResponse.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct LoginResponse: Codable {
    var id: Int
    var token, email: String
}
