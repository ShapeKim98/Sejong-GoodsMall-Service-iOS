//
//  OrderItem.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/27.
//

import Foundation

struct OrderItem: Codable, Hashable {
    var itemID: Int?
    var color, size: String?
    let quantity, price: Int
    var seller: Seller?
    
    enum CodingKeys: String, CodingKey {
        case color, size, quantity, price, seller
        case itemID = "itemId"
    }
}
