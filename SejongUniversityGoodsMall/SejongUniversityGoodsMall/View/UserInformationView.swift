//
//  UserInformationView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct UserInformationView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                wishList()
                    .padding([.horizontal, .top])
                
                orderHistory()
                    .padding([.horizontal, .top])
                
                helpArea()
                    .padding([.horizontal, .top])
                
                Spacer()
            }
        }
        .background(.white)
        .onAppear() {
            if !loginViewModel.isAuthenticate {
                appViewModel.createMessageBox(title: "로그인이 필요한 서비스 입니다", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러 가기", secondaryButtonTitle: "계속 둘러보기") {
                    withAnimation(.spring()) {
                        appViewModel.showMessageBoxBackground = false
                        appViewModel.showMessageBox = false
                    }
                    
                    loginViewModel.showLoginView = true
                    
                    dismiss()
                } secondaryButtonAction: {
                    withAnimation(.spring()) {
                        appViewModel.showMessageBoxBackground = false
                        appViewModel.showMessageBox = false
                    }
                    
                    dismiss()
                } closeButtonAction: {
                    appViewModel.deleteMessageBox()
                    
                    dismiss()
                }
                
                withAnimation(.spring()) {
                    appViewModel.showMessageBoxBackground = true
                    appViewModel.showMessageBox = true
                }
            } else {
                withAnimation(.easeInOut) {
                    goodsViewModel.isScrapListLoading = true
                }
                
                goodsViewModel.fetchScrapList(token: loginViewModel.returnToken())
                
                goodsViewModel.orderGoodsInfoList.removeAll()

                goodsViewModel.fetchOrderGoodsList(token: loginViewModel.returnToken())
            }
        }
    }
    
    @ViewBuilder
    func wishList() -> some View {
        VStack {
            HStack {
                Text("찜한 상품")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding()
            
            
            if goodsViewModel.scrapGoodsList.isEmpty && goodsViewModel.isScrapListLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .tint(Color("main-highlight-color"))
                    .unredacted()
            } else if goodsViewModel.scrapGoodsList.isEmpty {
                Text("찜한 상품이 없어요.")
                    .foregroundColor(Color("main-text-color"))
                    .padding()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(goodsViewModel.scrapGoodsList) { goods in
                            subWishGoods(goods: goods)
                                .redacted(reason: goodsViewModel.isScrapListLoading ? .placeholder : [])
                        }
                    }
                    .padding(.trailing)
                }
            }
            
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .black.opacity(0.15), radius: 2)
        }
    }
    
    @ViewBuilder
    func subWishGoods(goods: ScrapGoods) -> some View {
        VStack {
            AsyncImage(url: URL(string: goods.repImage.oriImgName)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ZStack {
                    Color("main-shape-bkg-color")
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    ProgressView()
                        .tint(Color("main-highlight-color"))
                }
            }
            .frame(width: 100, height: 100)
            .shadow(radius: 1)
            
            Text(goods.title)
                .font(.footnote)
                .foregroundColor(Color("main-text-color"))
            
            Text("\(goods.price)원")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(Color("main-text-color"))
        }
        .padding([.bottom, .leading])
    }
    
    @ViewBuilder
    func orderHistory() -> some View {
        VStack(spacing: 0) {
            NavigationLink {
                OrderHistoryView()
                    .navigationTitle("주문 내역")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
                    .onAppear() {
                        withAnimation(.easeInOut) {
                            goodsViewModel.isOrderGoodsListLoading = true
                        }

                        goodsViewModel.orderGoodsInfoList.removeAll()

                        goodsViewModel.fetchOrderGoodsList(token: loginViewModel.returnToken())
                    }
            } label: {
                HStack {
                    Text("주문 내역")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Label("다음", systemImage: "chevron.forward")
                        .labelStyle(.iconOnly)
                }
                .padding(.horizontal)
            }
            .foregroundColor(Color("main-text-color"))
            .padding()
            .background(alignment: .bottom) {
                Rectangle()
                    .fill(Color("secondary-text-color"))
                    .frame(height: 0.5)
            }
            
            HStack {
                Spacer()
                
                VStack {
                    Text("현장 수령")
                        .foregroundColor(Color("main-text-color"))
                    
                    Text("\(goodsViewModel.pickUpOrderCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-highlight-color"))
                }
                .padding(.vertical, 30)
                
                Spacer()
                
                Rectangle()
                    .fill(Color("secondary-text-color"))
                    .frame(width: 0.5)
                
                Spacer()
                
                VStack {
                    Text("택배 수령")
                        .foregroundColor(Color("main-text-color"))
                    
                    Text("\(goodsViewModel.deliveryOrderCount)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-highlight-color"))
                }
                .padding(.vertical, 30)
                
                Spacer()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .black.opacity(0.15), radius: 2)
        }
    }
    
    @ViewBuilder
    func helpArea() -> some View {
        VStack {
            HStack {
                Text("도움말")
                    .font(.headline)
                    .padding(.top, 25)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
            }
            
            NavigationLink {
                NoticeAndFAQView()
            } label: {
                HStack {
                    Text("공지사항")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("개인정보 처리 방침")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("이용약관 확인")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                        .padding(.bottom, 25)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .black.opacity(0.15), radius: 2)
        }
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                UserInformationView()
                    .environmentObject(AppViewModel())
                    .environmentObject(GoodsViewModel())
                    .environmentObject(LoginViewModel())
            }
        } else {
            NavigationView {
                UserInformationView()
                    .environmentObject(AppViewModel())
                    .environmentObject(GoodsViewModel())
                    .environmentObject(LoginViewModel())
            }
        }
    }
}
