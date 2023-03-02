//
//  ScrapGoods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/02.
//

import Foundation

struct ScrapGoods: Codable, Identifiable {
    let id: Int
    let title, description: String
    let price: Int
    let repImage: GoodsImage

    enum CodingKeys: String, CodingKey {
        case id = "itemId"
        case title, description, price, repImage
    }
}

typealias ScrapGoodsList = [ScrapGoods]
