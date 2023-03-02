//
//  OrderGoods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/19.
//

import Foundation

// MARK: - OrderGoods
struct OrderGoodsRequestFromDetailGoods: Codable {
    let buyerName, phoneNumber: String
    let address: Address?
    let orderMethod: String
    let deliveryRequest: String?
    let orderItems: [OrderItem]
}
