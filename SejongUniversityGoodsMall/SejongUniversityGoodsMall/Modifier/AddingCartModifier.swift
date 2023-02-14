//
//  AddingCartModifier.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/12.
//

import Foundation
import SwiftUI

struct AddingCartModifier: ViewModifier {
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @Binding var goods: Goods
    @Binding var selectedColor: String?
    @Binding var seletedSize: String?
    func body(content: Content) -> some View {
        if goods.color != nil, goods.size != nil {
            content
                .onChange(of: seletedSize) { newValue in
                    if newValue != nil, selectedColor != nil {
                        goodsViewModel.addRequestCart(quantity: 1, seletedColor: selectedColor, seletedSize: newValue)
                        selectedColor = nil
                        seletedSize = nil
                    }
                }
        } else if goods.color != nil, goods.size == nil {
            content
                .onChange(of: selectedColor) { newValue in
                    if newValue != nil {
                        goodsViewModel.addRequestCart(quantity: 1, seletedColor: newValue, seletedSize: seletedSize)
                        selectedColor = nil
                    }
                }
        } else if goods.color == nil, goods.size != nil {
            content
                .onChange(of: seletedSize) { newValue in
                    if newValue != nil {
                        goodsViewModel.addRequestCart(quantity: 1, seletedColor: selectedColor, seletedSize: newValue)
                        seletedSize = nil
                    }
                }
        }
    }
}
