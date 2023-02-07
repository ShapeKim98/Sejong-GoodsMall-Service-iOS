//
//  HomeView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

struct HomeView: View {
    enum Category: Int {
        case allProduct = 0
        case clothing = 1
        case office = 2
        case badgeAndKeyring = 3
        case forGift = 4
    }
    
    @Namespace var heroEffect
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State var selectedGoods: Goods?
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var category: Category = .allProduct
    
    @FocusState private var searchingFocused: Bool
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    init() {
        if #available(iOS 16.0, *) {
            
        } else {
            SetNavigationBarColor.navigationBarColors(background: .white, titleColor: UIColor(Color("main-text-color")))
        }
    }
    
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
                    }
                    .navigationTitle("")
                    .navigationBarBackButtonHidden()
                    .overlay {
                        if isSearching {
                            searchView()
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
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    .overlay {
                        if isSearching {
                            searchView()
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
                        .font(.title)
                        .labelStyle(.iconOnly)
                        .matchedGeometryEffect(id: "검색", in: heroEffect)
                }
            }
            
            Button {
                
            } label: {
                Label("장바구니", systemImage: "cart")
                    .font(.title)
                    .labelStyle(.iconOnly)
            }
            
            Button {
                
            } label: {
                Label("내정보", systemImage: "person")
                    .font(.title)
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
                            goodsViewModel.fetchGoodsList()
                        }
                    }
                    
                    categotyButton("문구", .office) {
                        withAnimation {
                            category = .office
                            goodsViewModel.fetchGoodsListFromCatefory(id: category.rawValue)
                        }
                    }
                    
                    categotyButton("의류", .clothing) {
                        withAnimation {
                            category = .clothing
                            goodsViewModel.fetchGoodsListFromCatefory(id: category.rawValue)
                        }
                    }
                    
                    categotyButton("뱃지&키링", .badgeAndKeyring) {
                        withAnimation {
                            category = .badgeAndKeyring
                            goodsViewModel.fetchGoodsListFromCatefory(id: category.rawValue)
                        }
                    }
                    
                    categotyButton("선물용", .forGift) {
                        withAnimation {
                            category = .forGift
//                            goodsViewModel.fetchGoodsListFromCatefory(id: category.rawValue)
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
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : nil)
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
                ForEach(goodsViewModel.goodsList) { item in
                    subGoodsView(item)
                        .coordinateSpace(name: "goods-list")
                }
                .redacted(reason: goodsViewModel.isLoading ? .placeholder : [])
            }
            .padding(.top)
        }
        .refreshable {
            goodsViewModel.fetchGoodsList()
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
        } label: {
            VStack {
                HStack(alignment: .top) {
                    if let image = goods.representativeImage() {
                        AsyncImage(url: URL(string: image.oriImgName)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: 130, height: 130)
                                .shadow(radius: 1)
                        } placeholder: {
                            ZStack {
                                Image("sample-image1")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(width: 130, height: 130)
                                    .shadow(radius: 1)
                                    .redacted(reason: .placeholder)
                                ProgressView()
                                    .tint(Color("main-highlight-color"))
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(goods.title)
                                    .foregroundColor(Color("main-text-color"))
                                    .font(.subheadline)
                                
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
        .simultaneousGesture(TapGesture().onEnded({
            selectedGoods = goods
        }))
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func searchView() -> some View {
        VStack(alignment: .leading) {
            HStack() {
                HStack {
                    Label("검색", systemImage: "magnifyingglass")
                        .labelStyle(.iconOnly)
                        .foregroundColor(Color("main-text-color").opacity(0.7))
                    
                    TextField("검색", text: $searchText, prompt: Text("상품을 검색해주세요").font(.footnote).foregroundColor(Color("main-text-color").opacity(0.7)))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .keyboardType(.default)
                        .submitLabel(.search)
                        .onSubmit {
//                            recentSearches.insert(searchText, at: 0)
                        }
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
                .padding(.horizontal)
                .padding(.vertical, 8)
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
                .foregroundColor(Color("secondary-text-color"))
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
            
            HStack {
                Text("최근 검색어")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
                
                Button("전체삭제", role: .destructive) {
//                    recentSearches.removeAll()
                }
                .font(.footnote)
                .foregroundColor(Color("main-highlight-color"))
            }
            .padding()
            .padding(.horizontal, 5)
            
            VStack {
//                ForEach(recentSearches, id: \.hashValue) { keyword in
//                    HStack {
//                        Button {
//
//                        } label: {
//                            HStack(spacing: 20) {
//                                Label("검색어", systemImage: "magnifyingglass")
//                                    .labelStyle(.iconOnly)
//                                    .foregroundColor(Color("main-text-color").opacity(0.7))
//                                    .padding(8)
//                                    .background {
//                                        Circle()
//                                            .foregroundColor(Color("shape-bkg-color"))
//                                    }
//
//                                Text(keyword)
//                                    .foregroundColor(Color("main-text-color"))
//
//                                Spacer()
//                            }
//                        }
//
//                        Button(role: .destructive) {
//
//                        } label: {
//                            Label("삭제", systemImage: "xmark")
//                                .labelStyle(.iconOnly)
//                        }
//                    }
//                    .padding(.horizontal)
//                    .padding(.vertical, 5)
//                }
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
