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
    @Binding var showDetailView: Bool
    
    @State private var searchText = ""
    @State private var category: Category = .allProduct
    
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    @State private var goods = [SampleGoodsModel(name: "학과 잠바", price: 85_000, image: "sample-image1", tag: ["#새내기", "#종이"], category: .clothing),
                         SampleGoodsModel(name: "큐브형 포스트잇", price: 3_000, image: "sample-image2", tag: ["#포스트잇", "#큐브형"], category: .phrases),
                         SampleGoodsModel(name: "뜯는 노트", price: 2_000, image: "sample-image3", tag: ["#뜯는 노트"], category: .phrases),
                         SampleGoodsModel(name: "스프링 노트", price: 1_500, image: "sample-image4", tag: ["#스프링 노트"], category: .phrases)
    ]
    
    @State private var filteredGoods = [SampleGoodsModel]()
    
    var body: some View {
        GeometryReader { reader in
            NavigationView {
                VStack {
                    Group {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color("secondary-text-color"))
                            
                            TextField("검색", text: $searchText, prompt: Text("종이의 취향을 검색해보세요"))
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
                                        filteredGoods = goods
                                    }
                                }
                                
                                categotyButton("문구", .phrases) {
                                    withAnimation {
                                        category = .phrases
                                        filteredGoods = goods.filter({ item in
                                            return item.category == .phrases
                                        })
                                    }
                                }
                                
                                categotyButton("의류", .clothing) {
                                    withAnimation {
                                        category = .clothing
                                        filteredGoods = goods.filter({ item in
                                            return item.category == .clothing
                                        })
                                    }
                                }
                                
                                categotyButton("뱃지&키링", .badgeAndKeyring) {
                                    withAnimation {
                                        category = .badgeAndKeyring
                                        filteredGoods = goods.filter({ item in
                                            return item.category == .badgeAndKeyring
                                        })
                                    }
                                }
                                
                                categotyButton("선물용", .forGift) {
                                    withAnimation {
                                        category = .forGift
                                        filteredGoods = goods.filter({ item in
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
                    .frame(height: reader.safeAreaInsets.top)
                    
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            ForEach(filteredGoods) { item in
                                subGoodsView(item)
                            }
                        }
                    }
                }
                .navigationBarHidden(true)
                .onAppear() {
                    filteredGoods = goods
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
                    .font(.subheadline)
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
            GoodsDetailView(showDetailView: $showDetailView, goods: goods)
                .onAppear() {
                    withAnimation {
                        showDetailView = true
                    }
                }
                .onDisappear() {
                    withAnimation {
                        showDetailView = false
                    }
                }
        } label: {
            VStack {
                HStack(alignment: .top) {
                    Image(goods.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 130, height: 130)
                        .shadow(radius: 1)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(goods.name)
                                .foregroundColor(Color("main-text-color"))
                            
                            HStack(spacing: 3) {
                                ForEach(goods.tag, id: \.hashValue) {
                                    Text($0)
                                        .font(.caption2)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showDetailView: .constant(false))
    }
}
