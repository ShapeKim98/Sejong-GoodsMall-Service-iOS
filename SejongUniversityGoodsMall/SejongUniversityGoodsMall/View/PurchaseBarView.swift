//
//  PurchaseBarView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI

struct PurchaseBarView: View {
    @Namespace var heroEffect
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @Binding var showOptionSheet: Bool
    @Binding var orderType: OrderType
    @State var isPresented: Bool = false
    
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
                .frame(height: 70)
                .background(.white)
        }
        .background(.clear)
        .modifier(NavigationPopModifierr(isPresented: $isPresented, destination: {
            OrderView(orderType: $orderType, orderGoods: [OrderItem(color: goodsViewModel.seletedGoods.color, size: goodsViewModel.seletedGoods.size, quantity: goodsViewModel.seletedGoods.quantity, price: goodsViewModel.goodsDetail.price)])
        }))
    }
    
    @State private var isWished: Bool = false
    
    func purchaseMode() -> some View {
        HStack(spacing: 20) {
            ZStack {
                if !showOptionSheet {
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
                    withAnimation {
                        goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                        goodsViewModel.seletedGoods.quantity = 0
                        goodsViewModel.seletedGoods.color = nil
                        goodsViewModel.seletedGoods.size = nil
                    }
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
                .frame(width: showOptionSheet ? nil : 30)
                .opacity(showOptionSheet ? 1 : 0)
                .disabled(!showOptionSheet)
            }
            
            if showOptionSheet {
                if #available(iOS 16.0, *) {
                    Button {
                        isPresented = true
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("주문하기")
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
                    .matchedGeometryEffect(id: "구매하기", in: heroEffect)
                } else {
                    ZStack {
                        NavigationLink(isActive: $isPresented) {
                            OrderView(orderType: $orderType, orderGoods: [OrderItem(color: goodsViewModel.seletedGoods.color, size: goodsViewModel.seletedGoods.size, quantity: goodsViewModel.seletedGoods.quantity, price: goodsViewModel.goodsDetail.price)])
                                .navigationTitle("주문서 작성")
                                .navigationBarTitleDisplayMode(.inline)
                                .modifier(NavigationColorModifier())
                        } label: {
                            EmptyView()
                        }

//                        NavigationLink(destination: OrderView(orderType: $orderType, orderGoods: [OrderItem(color: goodsViewModel.seletedGoods.color, size: goodsViewModel.seletedGoods.size, quantity: goodsViewModel.seletedGoods.quantity, price: goodsViewModel.goodsDetail.price)])
//                            .navigationTitle("주문서 작성")
//                            .navigationBarTitleDisplayMode(.inline)
//                            .modifier(NavigationColorModifier()), isActive: $isPresented, label: {})
                        //                    NavigationLink(isActive: $isPresented) {
                        //                        OrderView(orderType: $orderType, orderGoods: [OrderItem(color: goodsViewModel.seletedGoods.color, size: goodsViewModel.seletedGoods.size, quantity: goodsViewModel.seletedGoods.quantity, price: goodsViewModel.goodsDetail.price)])
                        //                            .navigationTitle("주문서 작성")
                        //                            .navigationBarTitleDisplayMode(.inline)
                        //                            .modifier(NavigationColorModifier())
                        //                    } label: {
                        //                        HStack {
                        //                            Spacer()
                        //
                        //                            Text("주문하기")
                        //                                .font(.subheadline)
                        //                                .fontWeight(.bold)
                        //                                .foregroundColor(.white)
                        //                                .padding(.vertical)
                        //
                        //                            Spacer()
                        //                        }
                        //                    }
                        //                    .background {
                        //                        RoundedRectangle(cornerRadius: 10)
                        //                            .foregroundColor(Color("main-highlight-color"))
                        //                    }
                        //                    .matchedGeometryEffect(id: "구매하기", in: heroEffect)
                        //                    .disabled(true)
                        //                    .overlay {
                        Button {
                            isPresented = true
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text("주문하기")
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
                        .matchedGeometryEffect(id: "구매하기", in: heroEffect)
                    }
//                    }
                }
            } else {
                Button {
                    withAnimation(.spring()) {
                        showOptionSheet = true
                    }
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("주문하기")
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
                .matchedGeometryEffect(id: "구매하기", in: heroEffect)
            }
        }
    }
}

struct PurchaseBarView_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseBarView(showOptionSheet: .constant(false), orderType: .constant(.pickUpOrder))
            .environmentObject(GoodsViewModel())
            .environmentObject(LoginViewModel())
    }
}
