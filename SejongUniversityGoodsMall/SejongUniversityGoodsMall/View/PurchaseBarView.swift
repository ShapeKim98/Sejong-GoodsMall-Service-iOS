//
//  PurchaseBarView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI

struct PurchaseBarView: View {
    @Environment(\.dismiss) var dismiss
    
    @Namespace var heroEffect
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @Binding var showOptionSheet: Bool
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
        .modifier(ShowOrderViewModifier(isPresented: $isPresented, destination: {
            OrderView(isPresented: $isPresented, orderGoods: [OrderItem(color: goodsViewModel.seletedGoods.color, size: goodsViewModel.seletedGoods.size, quantity: goodsViewModel.seletedGoods.quantity, price: goodsViewModel.goodsDetail.price)])
                .navigationTitle("주문서 작성")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
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
                    if !loginViewModel.isAuthenticate {
                        appViewModel.messageBoxTitle = "로그인이 필요한 서비스 입니다"
                        appViewModel.messageBoxSecondaryTitle = "로그인 하시겠습니까?"
                        appViewModel.messageBoxMainButtonTitle = "로그인 하러 가기"
                        appViewModel.messageBoxSecondaryButtonTitle = "계속 둘러보기"
                        appViewModel.messageBoxMainButtonAction = {
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = false
                                appViewModel.showMessageBox = false
                            }
                            
                            loginViewModel.showLoginView = true
                        }
                        appViewModel.messageBoxSecondaryButtonAction = {
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = false
                                appViewModel.showMessageBox = false
                            }
                        }
                        appViewModel.messageBoxCloseButtonAction = {
                            appViewModel.messageBoxTitle = ""
                            appViewModel.messageBoxSecondaryTitle = ""
                            appViewModel.messageBoxMainButtonTitle = ""
                            appViewModel.messageBoxSecondaryButtonTitle = ""
                            appViewModel.messageBoxMainButtonAction = {}
                            appViewModel.messageBoxSecondaryButtonAction = {}
                            appViewModel.messageBoxCloseButtonAction = {}
                            
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = false
                                appViewModel.showMessageBox = false
                            }
                        }
                        
                        
                        withAnimation(.spring()) {
                            appViewModel.showMessageBoxBackground = true
                            appViewModel.showMessageBox = true
                            
                        }
                    } else {
                        if goodsViewModel.isSendGoodsPossible {
                            appViewModel.messageBoxTitle = "담을 방법을 선택해 주세요"
                            appViewModel.messageBoxSecondaryTitle = "현장 수령 선택시 결제는 현장에서만 가능하고\n배송 신청 선택시 결제는 무통장 입금만 가능합니다"
                            appViewModel.messageBoxMainButtonTitle = "현장 수령하기"
                            appViewModel.messageBoxSecondaryButtonTitle = "택배 수령하기"
                            appViewModel.messageBoxMainButtonAction = {
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                                
                                withAnimation {
                                    goodsViewModel.seletedGoods.cartMethod = "pickup"
                                    goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                                    goodsViewModel.seletedGoods.quantity = 0
                                    goodsViewModel.seletedGoods.color = nil
                                    goodsViewModel.seletedGoods.size = nil
                                }
                            }
                            appViewModel.messageBoxSecondaryButtonAction = {
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                                
                                withAnimation {
                                    goodsViewModel.seletedGoods.cartMethod = "delivery"
                                    goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                                    goodsViewModel.seletedGoods.quantity = 0
                                    goodsViewModel.seletedGoods.color = nil
                                    goodsViewModel.seletedGoods.size = nil
                                }
                            }
                            appViewModel.messageBoxCloseButtonAction = {
                                appViewModel.messageBoxTitle = ""
                                appViewModel.messageBoxSecondaryTitle = ""
                                appViewModel.messageBoxMainButtonTitle = ""
                                appViewModel.messageBoxSecondaryButtonTitle = ""
                                appViewModel.messageBoxMainButtonAction = {}
                                appViewModel.messageBoxSecondaryButtonAction = {}
                                appViewModel.messageBoxCloseButtonAction = {}
                                
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                            }
                            
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = true
                                appViewModel.showMessageBox = true
                            }
                        }
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
                Button {
                    if goodsViewModel.isSendGoodsPossible {
                        appViewModel.messageBoxTitle = "주문 방법을 선택해 주세요"
                        appViewModel.messageBoxSecondaryTitle = "현장 수령 선택시 결제는 현장에서만 가능하고\n배송 신청 선택시 결제는 무통장 입금만 가능합니다"
                        appViewModel.messageBoxMainButtonTitle = "현장 수령하기"
                        appViewModel.messageBoxSecondaryButtonTitle = "택배 수령하기"
                        appViewModel.messageBoxMainButtonAction = {
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = false
                                appViewModel.showMessageBox = false
                                
                                goodsViewModel.orderType = .pickUpOrder
                                isPresented = true
                            }
                        }
                        appViewModel.messageBoxSecondaryButtonAction = {
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = false
                                appViewModel.showMessageBox = false
                            }
                            
                            goodsViewModel.orderType = .deliveryOrder
                            isPresented = true
                        }
                        appViewModel.messageBoxCloseButtonAction = {
                            appViewModel.messageBoxTitle = ""
                            appViewModel.messageBoxSecondaryTitle = ""
                            appViewModel.messageBoxMainButtonTitle = ""
                            appViewModel.messageBoxSecondaryButtonTitle = ""
                            appViewModel.messageBoxMainButtonAction = {}
                            appViewModel.messageBoxSecondaryButtonAction = {}
                            appViewModel.messageBoxCloseButtonAction = {}
                            
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = false
                                appViewModel.showMessageBox = false
                            }
                        }
                        
                        withAnimation(.spring()) {
                            appViewModel.showMessageBoxBackground = true
                            appViewModel.showMessageBox = true
                        }
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
        PurchaseBarView(showOptionSheet: .constant(false))
            .environmentObject(GoodsViewModel())
            .environmentObject(LoginViewModel())
            .environmentObject(AppViewModel())
    }
}
