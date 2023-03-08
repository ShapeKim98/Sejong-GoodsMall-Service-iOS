//
//  Address.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/27.
//

import Foundation

struct Address: Codable {
    let mainAddress, zipcode: String
    let detailAddress: String?
}
