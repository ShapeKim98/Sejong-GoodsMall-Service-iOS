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
    let seller: SellerForOrderGoodsResponse?
    let address: Address?
    let orderMethod, status: String?
    let createdAt: Date
    let orderItems: [OrderItem]
    let cartIDList: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, buyerName, phoneNumber, seller, address, orderMethod, status, createdAt, orderItems
        case cartIDList = "cartIdList"
    }
}

// MARK: - Seller
struct SellerForOrderGoodsResponse: Codable, Hashable {
    let createdAt, modifiedAt: Date
    let id: Int
    let name: String
    let phoneNumber: String
    let accountHolder: String
    let bank: String
    let account: String
    let method: String
}

typealias OrderGoodsRespnoseList = [OrderGoodsRespnose]
