//
//  GoodsListRequest.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/22.
//

import Foundation

struct GoodsListRequest: Codable {
    let memberID: Int?
    
    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
    }
}
