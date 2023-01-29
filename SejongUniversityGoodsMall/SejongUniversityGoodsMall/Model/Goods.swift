//
//  Goods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct Goods: Codable, Identifiable {
    var id = UUID()
    let title: String
    let price: Int
    let description: String?
}

typealias GoodsList = [Goods]
