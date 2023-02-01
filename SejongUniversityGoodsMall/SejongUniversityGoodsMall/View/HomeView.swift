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
    @Namespace var heroEffect
//    @EnvironmentObject var sampleGoodsViewModel: SampleGoodsViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State var selectedGoods: Goods?
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var category: Category = .allProduct
//    @State private var filteredGoods = [SampleGoodsModel]()
    
    @FocusState private var searchingFocused: Bool
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        GeometryReader { reader in
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            navigationBar()
                            
                            categorySelection()
                            
                            goodList()
                        }
                        .onAppear() {
//                            filteredGoods = sampleGoodsViewModel.goodsList
                        }
                    }
                    .navigationTitle("")
                    .navigationBarBackButtonHidden()
                    .overlay {
                        if isSearching {
                            searchView(popularKewords: [""])
                        }
                    }
                }
                .tint(Color("main-text-color"))
            } else {
                NavigationView {
                    ZStack(alignment: .top) {
                        VStack(spacing: 0) {
                            navigationBar()
                            
                            categorySelection()
                            
                            goodList()
                        }
                        .onAppear() {
//                            filteredGoods = sampleGoodsViewModel.goodsList
                        }
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .overlay {
                        if isSearching {
                            searchView(popularKewords: [""])
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        HStack(spacing: 15) {
            Text("앱 이름")
                .font(.title.bold())
            
            Spacer()
            
            Button {
                withAnimation(.spring()) {
                    isSearching = true
                    searchingFocused = true
                }
            } label: {
                if !isSearching {
                    Label("검색", systemImage: "magnifyingglass")
                        .font(.title2.bold())
                        .labelStyle(.iconOnly)
                        .matchedGeometryEffect(id: "검색", in: heroEffect)
                }
            }
            
            Button {
                
            } label: {
                Label("장바구니", systemImage: "cart")
                    .font(.title2.bold())
                    .labelStyle(.iconOnly)
            }
            
            Button {
                
            } label: {
                Label("내정보", systemImage: "person.circle.fill")
                    .font(.title2.bold())
                    .labelStyle(.iconOnly)
            }
        }
        .foregroundColor(Color("main-text-color"))
        .padding()
        .padding(.bottom)
    }
    
    @ViewBuilder
    func categorySelection() -> some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    categotyButton("전체 상품", .allProduct) {
                        withAnimation {
                            category = .allProduct
//                            filteredGoods = sampleGoodsViewModel.goodsList
                        }
                    }
                    
                    categotyButton("문구", .phrases) {
                        withAnimation {
                            category = .phrases
//                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
//                                return item.category == .phrases
//                            })
                        }
                    }
                    
                    categotyButton("의류", .clothing) {
                        withAnimation {
                            category = .clothing
//                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
//                                return item.category == .clothing
//                            })
                        }
                    }
                    
                    categotyButton("뱃지&키링", .badgeAndKeyring) {
                        withAnimation {
                            category = .badgeAndKeyring
//                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
//                                return item.category == .badgeAndKeyring
//                            })
                        }
                    }
                    
                    categotyButton("선물용", .forGift) {
                        withAnimation {
                            category = .forGift
//                            filteredGoods = sampleGoodsViewModel.goodsList.filter({ item in
//                                return item.category == .forGift
//                            })
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
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                
                Rectangle()
                    .foregroundColor(isSelected ? Color("main-highlight-color") : .clear)
                    .frame(height: 3)
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func goodList() -> some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(goodsViewModel.goodsList, id: \.title) { item in
                    subGoodsView(item)
                        .coordinateSpace(name: "goods-list")
                }
                .redacted(reason: goodsViewModel.isLoading ? .placeholder : [])
            }
            .padding(.top)
        }
    }
    
    @ViewBuilder
    func subGoodsView(_ goods: Goods) -> some View {
        NavigationLink {
            GoodsDetailView(goods: goods)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
        } label: {
            VStack {
                HStack(alignment: .top) {
                    Image("sample-image1")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(width: 130, height: 130)
                        .shadow(radius: 1)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(goods.title)
                                    .foregroundColor(Color("main-text-color"))
                                    .font(.system(size: 15))
                                
                                Spacer()
                            }
                            
                            HStack(spacing: 3) {
                                if let description = goods.description {
                                        Text(description)
                                            .font(.caption)
                                            .foregroundColor(Color("secondary-text-color"))
                                }
//                                ForEach(goods.description, id: \.hashValue) {
//                                    Text($0)
//                                        .font(.system(size: 10))
//                                        .foregroundColor(Color("secondary-text-color"))
//                                }
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
    
    @ViewBuilder
    func searchView(popularKewords: [String]) -> some View {
        VStack(alignment: .leading) {
            HStack() {
                HStack {
                    Label("검색", systemImage: "magnifyingglass")
                        .font(.headline.bold())
                        .labelStyle(.iconOnly)
                        .foregroundColor(Color("secondary-text-color"))
                    
                    TextField("검색", text: $searchText, prompt: Text("종이의 취향을 검색해보세요."))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($searchingFocused)
                    
                    if searchText != "" {
                        Button {
                            withAnimation {
                                searchText = ""
                            }
                        } label: {
                            Label("삭제", systemImage: "xmark.circle.fill")
                                .font(.headline.bold())
                                .labelStyle(.iconOnly)
                                .foregroundColor(Color("secondary-text-color"))
                        }
                        
                    }
                }
                .matchedGeometryEffect(id: "검색", in: heroEffect)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("shape-bkg-color"))
                }
                .padding(.horizontal, 5)
                
                Spacer()
                
                Button("취소") {
                    withAnimation(.spring()) {
                        searchingFocused = false
                        isSearching = false
                        searchText = ""
                    }
                }
                .padding(.horizontal, 5)
            }
            .padding()
            .background {
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(Color("shape-bkg-color"))
                        .frame(height: 1)
                }
            }
            
            Text("인기 검색어")
                .fontWeight(.bold)
                .foregroundColor(Color("main-text-color"))
                .padding()
                .padding(.horizontal, 5)
            
            HStack {
                VStack {
                    ForEach(popularKewords.indices) { rank in
                        Text("\(rank + 1)")
                            .padding()
                    }
                }
                
                VStack(alignment: .leading) {
                    ForEach(popularKewords, id: \.hashValue) { keyword in
                        Button(keyword) {
                            withAnimation {
                                searchText = keyword
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .foregroundColor(Color("main-text-color"))
            .padding(.horizontal, 5)
            
            Spacer()
        }
        .background(.white)
        .onTapGesture {
            searchingFocused = false
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(GoodsViewModel())
    }
}
