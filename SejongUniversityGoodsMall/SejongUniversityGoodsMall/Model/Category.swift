//
//  Category.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import Foundation

struct Category: Codable, Identifiable {
    let id: Int
    let name: String
    
    var categoryName: String {
        switch name {
            case "ALLPRODUCT":
                return "전체상품"
            case "CLOTHES":
                return "의류"
            case "OFFICE":
                return "문구"
            case "KEYRING":
                return "뱃지&키링"
            case "GIFT":
                return "선물용"
            default:
                return name
        }
    }
}

typealias CategoryList = [Category]
