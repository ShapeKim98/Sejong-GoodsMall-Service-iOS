//
//  PurchaseBarView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI

struct PurchaseBarView: View {
    @Binding var showOptionSheet: Bool
    
    @State var selectedGoods: SampleGoodsModel
    
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
                .padding(.vertical, 7.3)
                .padding(.horizontal, 20)
                .background(.white)
        }
        .background(.clear)
    }
    
    func purchaseMode(_ goods: SampleGoodsModel) -> some View {
        HStack {
            if showOptionSheet {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color("main-highlight-color"))
                        .frame(width: 160)
                    
                    Button {
                        withAnimation(.spring()) {
                            
                        }
                    } label: {
                        Text("장바구니 담기")
                            .font(.system(size: 15).bold())
                            .foregroundColor(Color("main-highlight-color"))
                            .padding(.vertical, 8)
                    }
                }
            } else {
                Text("\(goods.price)원")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
            }
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(Color("main-highlight-color"))
                    .frame(width: 160)
                
                Button {
                    
                    withAnimation(.spring()) {
                        showOptionSheet = true
                    }
                } label: {
                    Text("구매하기")
                        .font(.system(size: 15).bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

struct PurchaseBarView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseBarView(showOptionSheet: .constant(false), selectedGoods: SampleGoodsModel(name: "학과 잠바", price: 85_000, image: "sample-image1", tag: ["#새내기", "#종이"], category: .clothing))
    }
}
