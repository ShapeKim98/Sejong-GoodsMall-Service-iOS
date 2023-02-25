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
    var cartMethod: String?
}
