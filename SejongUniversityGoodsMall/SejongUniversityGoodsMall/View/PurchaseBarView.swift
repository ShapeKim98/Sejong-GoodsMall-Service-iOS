//
//  PurchaseBarView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI

struct PurchaseBarView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @Binding var showOptionSheet: Bool
    
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
            
            purchaseMode()
                .padding(.vertical, 8)
                .padding(.horizontal, 25)
                .background(.white)
        }
        .background(.clear)
    }
    
    @State private var isWished: Bool = false
    
    func purchaseMode() -> some View {
        HStack(spacing: 20) {
            if showOptionSheet {
                Button {
                    goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                    goodsViewModel.cartRequest.removeAll()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("장바구니 담기")
                            .font(.subheadline.bold())
                            .foregroundColor(Color("main-highlight-color"))
                            .padding(.vertical)
                        
                        Spacer()
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("main-highlight-color"))
                }
            } else {
                Button {
                    withAnimation {
                        isWished.toggle()
                    }
                } label: {
                    VStack(spacing: 0) {
                        if isWished {
                            Image(systemName: "heart.fill")
                                .font(.title2)
                                .foregroundColor(Color("main-highlight-color"))
                        } else {
                            Image(systemName: "heart")
                                .font(.title2)
                        }
                        
                        Text("찜하기")
                            .font(.caption2)
                    }
                }
                .foregroundColor(Color("main-text-color"))
            }
            
            Button {
                withAnimation(.spring()) {
                    showOptionSheet = true
                }
            } label: {
                HStack {
                    Spacer()
                    
                    Text("구매하기")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                    
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("main-highlight-color"))
            }
        }
    }
}

struct PurchaseBarView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseBarView(showOptionSheet: .constant(false))
            .environmentObject(GoodsViewModel())
            .environmentObject(LoginViewModel())
    }
}
