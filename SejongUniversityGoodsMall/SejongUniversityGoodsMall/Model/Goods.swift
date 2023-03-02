//
//  Goods.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation

struct Goods: Codable, Identifiable {
    let id: Int
    let categoryID: Int
    let categoryName: String
    let title: String
    let color, size: String?
    let price: Int
    let seller: Seller
    let goodsImages: [GoodsImage]
    let goodsInfos: [GoodsInfo]
    let description: String?
    let cartItemCount: Int
    let scrapCount: Int
    let scraped: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case categoryID = "categoryId"
        case goodsImages = "itemImages"
        case goodsInfos = "itemInfos"
        case categoryName, title, color, size, price, seller, description, cartItemCount, scrapCount, scraped
    }
 
    func representativeImage() -> GoodsImage? {
        let index = self.goodsImages.firstIndex { image in
            return image.repImgURL == .y
        }
        
        guard let i = index else {
            return nil
        }
        
        return self.goodsImages[i]
    }
}

struct GoodsInfo: Codable {
    let infoURL: String

    enum CodingKeys: String, CodingKey {
        case infoURL = "infoUrl"
    }
}

typealias GoodsList = [Goods]
