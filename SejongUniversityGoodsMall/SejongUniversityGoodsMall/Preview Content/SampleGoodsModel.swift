//
//  SampleGoodsModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import Foundation

struct SampleGoodsModel: Identifiable {
    var id = UUID()
    var name: String
    var price: Int
    var image: String
    var tag: [String]
    var category: Category
    var goodsInfo: String = "상품 설명과 상품 사이즈 등을 텍스트, 이미지로 표시"
    
    enum Category: Int {
        case allProduct
        case phrases
        case clothing
        case badgeAndKeyring
        case forGift
    }
}
