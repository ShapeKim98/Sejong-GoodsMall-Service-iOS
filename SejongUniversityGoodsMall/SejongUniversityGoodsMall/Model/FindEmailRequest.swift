//
//  FindEmailRequest.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct FindEmailRequest: Codable {
    var userName: String
    var birth: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username", birth
    }
}
