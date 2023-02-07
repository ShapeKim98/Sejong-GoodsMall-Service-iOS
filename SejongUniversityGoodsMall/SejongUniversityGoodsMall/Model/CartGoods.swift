//
//  CartGoods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/07.
//

import Foundation

import Foundation

struct CartGoods: Codable {
    var id: Int?
    var memberID, goodsID, quantity: Int
    var color, size: String?
    var price: Int

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case goodsID = "itemId"
        case quantity, color, size, price
    }
}

typealias Cart = [CartGoods]
