//
//  UpdatePaswordRequest.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/05.
//

import Foundation

struct UpdatePasswordRequest: Codable {
    let email: String
    let password: String
}
