//
//  SampleBasketItem:Model.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/26.
//

import Foundation

struct SampleBasketItemModel: Identifiable {
    var id = UUID()
    var goods: SampleGoodsModel
    var goodsCount = 1
}
