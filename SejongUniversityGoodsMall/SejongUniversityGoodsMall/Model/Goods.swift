//
//  Goods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct Goods: Codable {
    let id: Int
    let categoryID: Int?
    let title: String
    let color, size: String?
    let price: Int
    let goodsImages: [GoodsImage]
    let description: String

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "categoryId"
        case goodsImages = "itemImages"
        case title, color, size, price, description
    }
    
    func representativeImage() -> GoodsImage? {
        let index = self.goodsImages.firstIndex { image in
            return image.repImgURL == "Y"
        }
        
        guard let i = index else {
            return nil
        }
        
        return self.goodsImages[i]
    }
}

struct GoodsImage: Codable {
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

typealias GoodsList = [Goods]
