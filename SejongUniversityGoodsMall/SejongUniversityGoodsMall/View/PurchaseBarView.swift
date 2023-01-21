//
//  PurchaseBarView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI

struct PurchaseBarView: View {
    @State var selectedGoods: SampleGoodsModel
    @State var showSelectOption: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.black.opacity(0),
                                    .black.opacity(0.1),
                                    .black.opacity(0.2),
                                    .black.opacity(0.3)
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 5)
            .opacity(0.3)
            .background(.clear)
            
            purchaseMode(selectedGoods)
        }
        .background(.clear)
//        .modifier(OptionSheetModifier(showSelectOption: $showSelectOption))
    }
    
    func purchaseMode(_ goods: SampleGoodsModel) -> some View {
        HStack {
            Text("\(goods.price)원")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("main-text-color"))
            
            Spacer()
            
            Button {
                withAnimation {
                    showSelectOption = true
                }
            } label: {
                Text("구매하기")
                    .foregroundColor(.white)
                    .padding(8)
                    .padding(.horizontal, 30)
                    .background {
                        RoundedRectangle(cornerRadius: 40)
                            .foregroundColor(Color("main-highlight-color"))
                    }
            }
        }
        .padding(.vertical, 7.3)
        .padding(.horizontal)
        .background(.white)
    }
}

struct PurchaseBarView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseBarView(selectedGoods: SampleGoodsModel(name: "학과 잠바", price: 85_000, image: "sample-image1", tag: ["#새내기", "#종이"], category: .clothing))
    }
}
