//
//  OrderGoods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/19.
//

import Foundation

// MARK: - OrderGoods
struct OrderGoods: Codable {
    let buyerName, phoneNumber: String
    let address: Address?
    let orderItems: [OrderItem]
    
    var price: Int {
        var sum: Int = 0
        orderItems.forEach { goods in
            sum += goods.price
        }
        
        return sum
    }
}

// MARK: - Address
struct Address: Codable {
    let mainAddress, detailAddress, zipcode: String?
}

// MARK: - OrderItem
struct OrderItem: Codable, Hashable {
    let color, size: String?
    let quantity, price: Int
}
