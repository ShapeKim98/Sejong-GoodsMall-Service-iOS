//
//  HomeView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

enum Category: Int {
    case allProduct
    case phrases
    case clothing
    case badgeAndKeyring
    case forGift
}

struct HomeView: View {
    @EnvironmentObject var sampleGoodsViewModel: SampleGoodsViewModel
    
    @State var selectedGoods: SampleGoodsModel?
    @State private var searchText = ""
    @State private var category: Category = .allProduct
    @State private var filteredGoods = [SampleGoodsModel]()
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    toolBar()
                    
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(filteredGoods) { item in
                                subGoodsView(item)
                            }
                        }
                        .padding(.top)
                    }
                }
                .navigationBarHidden(true)
                .onAppear() {
                    filteredGoods = sampleGoodsViewModel.goodsList
                }
                .frame(height: reader.size.height - reader.frame(in: .named("TabBar")).minY + 10)
                
                
            }
        }
    }
    
    @ViewBuilder
    func toolBar() -> some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 15))
                    .foregroundColor(Color("secondary-text-color"))
                
                TextField("검색", text: $searchText, prompt: Text("종이의 취향을 검색해보세요").font(.system(size: 15)))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 40)
                    .foregroundColor(Color("shape-bkg-color"))
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    categotyButton("전체 상품", .allProduct) {
                        withAnimation {
                            category = .allProduct
                            filteredGoods = sampleGoodsViewModel.goodsList
                        }
                    }
                    
                    categotyButton("문구", .phrases) {
                        withAnimation {
                            category = .phrases
                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
                                return item.category == .phrases
                            })
                        }
                    }
                    
                    categotyButton("의류", .clothing) {
                        withAnimation {
                            category = .clothing
                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
                                return item.category == .clothing
                            })
                        }
                    }
                    
                    categotyButton("뱃지&키링", .badgeAndKeyring) {
                        withAnimation {
                            category = .badgeAndKeyring
                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
                                return item.category == .badgeAndKeyring
                            })
                        }
                    }
                    
                    categotyButton("선물용", .forGift) {
                        withAnimation {
                            category = .forGift
                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
                                return item.category == .forGift
                            })
                        }
                    }
                }
                .padding(.horizontal)
            }
            .background {
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(Color("shape-bkg-color"))
                        .frame(height: 1)
                }
            }
        }
    }
    
    @ViewBuilder
    func categotyButton(_ title: String, _ seleted: Category, _ action: @escaping () -> Void) -> some View {
        let isSelected = category == seleted
        
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                
                Rectangle()
                    .foregroundColor(isSelected ? Color("main-highlight-color") : .clear)
                    .frame(height: 3)
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func subGoodsView(_ goods: SampleGoodsModel) -> some View {
        NavigationLink {
            GoodsDetailView(goods: goods)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
        } label: {
            VStack {
                HStack(alignment: .top) {
                    Image(goods.image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 130, height: 130)
                        .shadow(radius: 1)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(goods.name)
                                    .foregroundColor(Color("main-text-color"))
                                    .font(.system(size: 15))
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 3) {
                                ForEach(goods.tag, id: \.hashValue) {
                                    Text($0)
                                        .font(.system(size: 10))
                                        .foregroundColor(Color("secondary-text-color"))
                                }
                            }
                        }
                        
                        Text("\(goods.price)원")
                            .font(.system(size: 18))
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
        .simultaneousGesture(TapGesture().onEnded({
            selectedGoods = goods
        }))
        .padding(.horizontal)
    }
    
    
}

struct Previews_HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SampleGoodsViewModel())
    }
}
