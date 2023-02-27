//
//  CartGoods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/07.
//

import Foundation

struct CartGoodsResponse: Codable, Identifiable {
    let id, memberID, goodsID: Int
    var quantity: Int
    let color, size: String?
    var price: Int
    let title: String
    let repImage: RepImage
    let seller: String
    let cartMethod: String

    enum CodingKeys: String, CodingKey {
        case id
        case memberID = "memberId"
        case goodsID = "itemId"
        case quantity, color, size, price, title, repImage, seller, cartMethod
    }
}

struct RepImage: Codable, Hashable {
    let id: Int
    let imgName: String
    let oriImgName: String
    let imgURL, repImgURL: String

    enum CodingKeys: String, CodingKey {
        case id, imgName, oriImgName
        case imgURL = "imgUrl"
        case repImgURL = "repImgUrl"
    }
}

typealias CartGoodsList = [CartGoodsResponse]
