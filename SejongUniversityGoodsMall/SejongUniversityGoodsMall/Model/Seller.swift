//
//  Seller.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/28.
//

import Foundation

struct Seller: Codable, Hashable {
    let createdAt, modifiedAt: Date
    let id: Int
    let name: String
    let phoneNumber: String
    let accountHolder: String
    let bank: String
    let account: String
    let method: SellerMethod
}

enum SellerMethod: String, Codable {
    case pickUp = "pickup"
    case delivery = "delivery"
    case both = "both"
}
