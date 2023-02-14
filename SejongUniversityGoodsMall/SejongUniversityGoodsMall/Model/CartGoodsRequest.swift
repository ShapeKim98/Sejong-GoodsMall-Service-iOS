//
//  CartGoodsRequest.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/11.
//

import Foundation
 
struct CartGoodsRequest: Codable, Hashable {
    var quantity: Int
    let color: String?
    let size: String?
}

typealias CartRequest = [CartGoodsRequest]
