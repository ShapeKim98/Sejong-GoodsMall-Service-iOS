//
//  OrderItem.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/27.
//

import Foundation

struct OrderItem: Codable, Hashable {
    let color, size: String?
    let quantity, price: Int
    var seller: SellerForOrderGoodsResponse?
}
