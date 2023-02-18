//
//  UpdateCartGoodsRequest.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/18.
//

import Foundation

struct UpdateCartGoodsRequest: Codable {
    let id: Int
    let quantity: Int
}
