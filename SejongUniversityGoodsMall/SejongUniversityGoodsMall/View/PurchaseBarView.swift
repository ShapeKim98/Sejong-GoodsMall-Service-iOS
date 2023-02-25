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
                        appViewModel.messageBox = MessageBoxView(showMessageBox: $appViewModel.showMessageBox, title: "로그인이 필요한 서비스 입니다", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러 가기", secondaryButtonTitle: "계속 둘러보기") {
                            withAnimation(.spring()) {
                                appViewModel.showAlertView = false
                                appViewModel.showMessageBox = false
                            }
                            
                            loginViewModel.showLoginView = true
                        } secondaryButtonAction: {
                            withAnimation(.spring()) {
                                appViewModel.showAlertView = false
                                appViewModel.showMessageBox = false
                            }
                        } closeButtonAction: {
                            withAnimation(.spring()) {
                                appViewModel.showAlertView = false
                                appViewModel.showMessageBox = false
                            }
                        } onDisAppearAction: {
                            appViewModel.messageBox = nil
                        }
                        
                        withAnimation(.spring()) {
                            appViewModel.showAlertView = true
                            appViewModel.showMessageBox = true
                        }
                    } else {
                        if goodsViewModel.isSendGoodsPossible {
                            appViewModel.messageBox = MessageBoxView(showMessageBox: $appViewModel.showMessageBox, title: "담을 방법을 선택해 주세요", secondaryTitle: "현장 수령 선택시 결제는 현장에서만 가능하고\n배송 신청 선택시 결제는 무통장 입금만 가능합니다", mainButtonTitle: "현장 수령하기", secondaryButtonTitle: "택배 수령하기") {
                                withAnimation(.spring()) {
                                    appViewModel.showAlertView = false
                                    appViewModel.showMessageBox = false
                                }
                                
                                withAnimation {
                                    goodsViewModel.seletedGoods.cartMethod = "pickup"
                                    goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                                    goodsViewModel.seletedGoods.quantity = 0
                                    goodsViewModel.seletedGoods.color = nil
                                    goodsViewModel.seletedGoods.size = nil
                                }
                            } secondaryButtonAction: {
                                withAnimation(.spring()) {
                                    appViewModel.showAlertView = false
                                    appViewModel.showMessageBox = false
                                }
                                
                                withAnimation {
                                    goodsViewModel.seletedGoods.cartMethod = "delivery"
                                    goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                                    goodsViewModel.seletedGoods.quantity = 0
                                    goodsViewModel.seletedGoods.color = nil
                                    goodsViewModel.seletedGoods.size = nil
                                }
                            } closeButtonAction: {
                                withAnimation(.spring()) {
                                    appViewModel.showAlertView = false
                                    appViewModel.showMessageBox = false
                                }
                            } onDisAppearAction: {
                                appViewModel.messageBox = nil
                            }
                            
                            withAnimation(.spring()) {
                                appViewModel.showAlertView = true
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
                        appViewModel.messageBox = MessageBoxView(showMessageBox: $appViewModel.showMessageBox, title: "담을 방법을 선택해 주세요", secondaryTitle: "현장 수령 선택시 결제는 현장에서만 가능하고\n배송 신청 선택시 결제는 무통장 입금만 가능합니다", mainButtonTitle: "현장 수령하기", secondaryButtonTitle: "택배 수령하기") {
                            withAnimation(.spring()) {
                                appViewModel.showAlertView = false
                                appViewModel.showMessageBox = false
                            }
                            
                            goodsViewModel.orderType = .pickUpOrder
                            isPresented = true
                        } secondaryButtonAction: {
                            withAnimation(.spring()) {
                                appViewModel.showAlertView = false
                                appViewModel.showMessageBox = false
                            }
                            
                            goodsViewModel.orderType = .deliveryOrder
                            isPresented = true
                        } closeButtonAction: {
                            withAnimation(.spring()) {
                                appViewModel.showAlertView = false
                                appViewModel.showMessageBox = false
                            }
                        } onDisAppearAction: {
                            appViewModel.messageBox = nil
                        }
                        
                        withAnimation(.spring()) {
                            appViewModel.showAlertView = true
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
