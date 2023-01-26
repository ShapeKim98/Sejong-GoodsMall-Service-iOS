//
//  SampleGoodsViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/24.
//

import Foundation

class SampleGoodsViewModel: ObservableObject {
    @Published var goodsList: [SampleGoodsModel] = [SampleGoodsModel(name: "학과 잠바", price: 85_000, image: "sample-image1", tag: ["#새내기", "#종이"], category: .clothing, options: [["블랙", "카키", "핑크", "그린"], ["S", "M", "L", "XL"]]),
                                                    SampleGoodsModel(name: "큐브형 포스트잇", price: 3_000, image: "sample-image2", tag: ["#포스트잇", "#큐브형"], category: .phrases),
                                                    SampleGoodsModel(name: "뜯는 노트", price: 2_000, image: "sample-image3", tag: ["#뜯는 노트"], category: .phrases),
                                                    SampleGoodsModel(name: "스프링 노트", price: 1_500, image: "sample-image4", tag: ["#스프링 노트"], category: .phrases)
    ]
}
