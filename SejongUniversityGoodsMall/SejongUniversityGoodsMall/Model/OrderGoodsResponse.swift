//
//  OrderGoodsResponse.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/27.
//

import Foundation

struct OrderGoodsRespnose: Codable, Identifiable {
    let id: Int?
    let buyerName, phoneNumber: String
    let seller: Seller?
    let address: Address?
    let orderMethod: OrderType
    let status: String?
    let createdAt: Date
    let deliveryRequest: String?
    let orderItems: [OrderItem]
    let cartIDList: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, buyerName, phoneNumber, seller, address, orderMethod, status, createdAt, orderItems, deliveryRequest
        case cartIDList = "cartIdList"
    }
}

typealias OrderGoodsRespnoseList = [OrderGoodsRespnose]
