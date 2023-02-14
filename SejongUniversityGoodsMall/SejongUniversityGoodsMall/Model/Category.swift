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
        switch id {
            case 0 where name == "ALLPRODUCT":
                return "전체상품"
            case 1 where name == "CLOTHES":
                return "의류"
            case 2 where name == "OFFICE":
                return "문구"
            case 3 where name == "KEYRING":
                return "뱃지&키링"
            case 4 where name == "GIFT":
                return "선물용"
            default:
                return name
        }
    }
}

typealias CategoryList = [Category]
