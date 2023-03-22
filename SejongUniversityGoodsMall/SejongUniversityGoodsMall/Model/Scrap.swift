//
//  Scrap.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/04.
//

import Foundation

struct Scrap: Codable {
    let memberID: Int
    let itemID: Int
    let scrapCount: Int
    
    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case itemID = "itemId"
        case scrapCount
    }
}
