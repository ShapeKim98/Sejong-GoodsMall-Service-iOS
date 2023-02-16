//
//  CartGoodsRequest.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/11.
//

import Foundation
 
struct CartGoodsRequest: Codable {
    var quantity: Int
    var color: String?
    var size: String?
    
    init(quantity: Int, color: String? = nil, size: String? = nil) {
        self.quantity = quantity
        self.color = color
        self.size = size
    }
}

typealias CartRequest = [CartGoodsRequest]
