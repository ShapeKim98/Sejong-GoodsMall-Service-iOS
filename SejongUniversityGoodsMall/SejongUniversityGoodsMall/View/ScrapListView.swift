//
//  WishListView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct ScrapListView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        VStack {
            if goodsViewModel.scrapGoodsList.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .tint(Color("main-highlight-color"))
                    .unredacted()
                
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(goodsViewModel.scrapGoodsList) { goods in
                            subGoodsView(goods)
                        }
                        .redacted(reason: goodsViewModel.isScrapListLoading ? .placeholder : [])
                    }
                    .padding(.top)
                }
            }
        }
        .onAppear() {
            withAnimation(.easeInOut) {
                goodsViewModel.isScrapListLoading = true
            }
            
            goodsViewModel.fetchScrapList(token: loginViewModel.returnToken())
        }
    }
    
    @ViewBuilder
    func subGoodsView(_ goods: ScrapGoods) -> some View {
        NavigationLink {
            GoodsDetailView()
                .onAppear(){
                    withAnimation(.easeInOut) {
                        goodsViewModel.isGoodsDetailLoading = true
                    }
                    goodsViewModel.fetchGoodsDetail(id: goods.id, token: loginViewModel.returnToken())
                }
                .navigationTitle("상품 정보")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
                .redacted(reason: goodsViewModel.isGoodsDetailLoading ? .placeholder : [])
        } label: {
            VStack {
                HStack(alignment: .top) {
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
                        .frame(width: 115, height: 115)
                        .shadow(radius: 1)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(goods.title)
                                    .foregroundColor(Color("main-text-color"))
                                    .font(.subheadline)
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 3) {
                                Text(goods.description)
                                    .font(.caption)
                                    .foregroundColor(Color("secondary-text-color"))
                            }
                        }
                        
                        Text("\(goods.price)원")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 5)
                    
                    Spacer()
                }
                
                Rectangle()
                    .foregroundColor(Color("shape-bkg-color"))
                    .frame(height: 1)
                    .padding(.vertical, 5)
            }
        }
        .padding(.horizontal)
    }
}

struct WishListView_Previews: PreviewProvider {
    static var previews: some View {
        ScrapListView()
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
    }
}
