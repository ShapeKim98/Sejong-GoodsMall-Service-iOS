//
//  PurchaseBarView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI

struct PurchaseBarView: View {
    @Binding var showOptionSheet: Bool
    
    @State var selectedGoods: Goods
    
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
    
    func purchaseMode(_ goods: Goods) -> some View {
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
                            .font(.subheadline.bold())
                            .foregroundColor(Color("main-highlight-color"))
                            .padding(.vertical, 8)
                    }
                }
            } else {
                Text("\(goods.price)원")
                    .font(.title3)
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
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

struct PurchaseBarView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseBarView(showOptionSheet: .constant(false), selectedGoods: Goods(id: 0, categoryID: 1, title: "학잠", color: "BLACK, BLUE, WHITE", size: "S, M, L", price: 0, goodsImages: [], description: "학잠"))
    }
}
