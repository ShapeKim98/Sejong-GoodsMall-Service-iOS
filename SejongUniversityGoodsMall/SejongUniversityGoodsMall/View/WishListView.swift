//
//  WishListView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct WishListView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State private var isWisedGoods: [Int: Bool] = [Int: Bool]()
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(goodsViewModel.goodsList) { item in
                    subGoodsView(item)
                }
                .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
            }
            .padding(.top)
        }
        .onAppear() {
            goodsViewModel.goodsList.forEach { goods in
                isWisedGoods.updateValue(true, forKey: goods.id)
            }
        }
    }
    
    @ViewBuilder
    func subGoodsView(_ goods: Goods) -> some View {
        NavigationLink {
            GoodsDetailView()
                .onAppear(){
                    goodsViewModel.fetchGoodsDetail(id: goods.id)
                }
                .navigationTitle("상품 정보")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
                .redacted(reason: goodsViewModel.isGoodsDetailLoading ? .placeholder : [])
        } label: {
            VStack {
                HStack(alignment: .top) {
                    if let image = goods.representativeImage() {
                        AsyncImage(url: URL(string: image.oriImgName)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            ZStack {
                                Color("shape-bkg-color")
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                ProgressView()
                                    .tint(Color("main-highlight-color"))
                            }
                        }
                        .frame(width: 115, height: 115)
                        .shadow(radius: 1)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(goods.title)
                                    .foregroundColor(Color("main-text-color"))
                                    .font(.subheadline)
                                
                                Spacer()
                                
                                Button {
                                    withAnimation {
                                        isWisedGoods[goods.id] = isWisedGoods[goods.id] ?? false ? false : true
                                    }
                                } label: {
                                    VStack(spacing: 0) {
                                        if isWisedGoods[goods.id] ?? false {
                                            Image(systemName: "heart.fill")
                                                .font(.title2)
                                                .foregroundColor(Color("main-highlight-color"))
                                        } else {
                                            Image(systemName: "heart")
                                                .font(.title2)
                                        }
                                    }
                                }
                                .foregroundColor(Color("main-text-color"))
                                .unredacted()
                            }
                            
                            HStack(spacing: 3) {
                                if let description = goods.description {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(Color("secondary-text-color"))
                                }
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
        WishListView()
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
    }
}
