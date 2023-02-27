//
//  OrderGoodsFromCart.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/27.
//

import Foundation

struct OrderGoodsRequestFromCart: Codable {
    let buyerName, phoneNumber: String
    let address: Address?
    let orderMethod: String
    let cartIDList: [Int]
    
    enum CodingKeys: String, CodingKey {
        case buyerName, phoneNumber, address, orderMethod
        case cartIDList = "cartIdList"
    }
}
