//
//  UserInformationView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct UserInformationView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                wishListArea()
                    .padding()
                
                orderHistoryArea()
                    .padding([.horizontal, .bottom])
                
//                accountManageArea()
//                    .padding([.horizontal, .bottom])
                
                helpArea()
                    .padding(.horizontal)
                
                Spacer()
            }
        }
        .background(.white)
    }
    
    @ViewBuilder
    func wishListArea() -> some View {
        VStack {
            NavigationLink {
                WishListView()
                    .navigationTitle("찜한 상품")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
            } label: {
                HStack {
                    Text("찜한 상품")
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(goodsViewModel.goodsList) { goods in
                        subWishGoods(goods: goods)
                            .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                    }
                }
                .padding(.trailing)
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
    func subWishGoods(goods: Goods) -> some View {
        VStack {
            if let image = goods.representativeImage() {
                AsyncImage(url: URL(string: image.oriImgName)) { image in
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
            } else {
                Color("main-shape-bkg-color")
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 1)
            }
            
            Text(goods.title)
                .font(.footnote)
                .foregroundColor(Color("secondary-text-color"))
            
            Text("\(goods.price)원")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(Color("secondary-text-color"))
        }
        .padding([.bottom, .leading])
    }
    
    @ViewBuilder
    func orderHistoryArea() -> some View {
        VStack(spacing: 0) {
            NavigationLink {
                
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
                        .foregroundColor(Color("secondary-text-color").opacity(0.7))
                    
                    Text("\(0)")
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
                        .foregroundColor(Color("secondary-text-color").opacity(0.7))
                    
                    Text("\(0)")
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
    func accountManageArea() -> some View {
        VStack {
            HStack {
                Text("계정")
                    .font(.headline)
                    .padding(.top, 25)
                
                Spacer()
            }
            
            Button {
                withAnimation(.spring()) {
                    appViewModel.showAlertView = true
                    appViewModel.showNeedLoginMessageBox = true
                }
            } label: {
                HStack {
                    Text("내 정보 변경")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("주문 내역")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("로그아웃")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("회원탈퇴")
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
                .stroke(Color("main-text-color"), lineWidth: 0.25)
        }
    }
    
    @ViewBuilder
    func helpArea() -> some View {
        VStack {
            HStack {
                Text("도움말")
                    .font(.headline)
                    .padding(.top, 25)
                
                Spacer()
            }
            
            NavigationLink {
                
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
            }
        } else {
            NavigationView {
                UserInformationView()
                    .environmentObject(AppViewModel())
                    .environmentObject(GoodsViewModel())
            }
        }
    }
}