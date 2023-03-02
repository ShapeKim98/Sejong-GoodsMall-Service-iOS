//
//  GoodsImage.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/02.
//

import Foundation

struct GoodsImage: Codable {
    let id: Int
    let imgName: String
    let oriImgName: String
    let imgURL: String
    let repImgURL: RepImgURL

    enum CodingKeys: String, CodingKey {
        case id, imgName, oriImgName
        case imgURL = "imgUrl"
        case repImgURL = "repImgUrl"
    }
}

enum RepImgURL: String, Codable {
    case n = "N"
    case y = "Y"
}
