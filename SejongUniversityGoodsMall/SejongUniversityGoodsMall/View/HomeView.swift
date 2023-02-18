//
//  HomeView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

struct HomeView: View {
    @Namespace var heroEffect
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
   
    @State private var currentCategory: Category = Category(id: 0, name: "ALLPRODUCT")
    
    
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
                }
                .tint(Color("main-text-color"))
                .overlay {
                    ZStack {
                        if appViewModel.showAlertView {
                            Color(.black).opacity(0.4)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        appViewModel.showAlertView = false
                                        appViewModel.showNeedLoginMessageBox = false
                                    }
                                }
                        }
                        
                        if appViewModel.showNeedLoginMessageBox {
                            MessageBoxView(showMessageBox: $appViewModel.showNeedLoginMessageBox, title: "로그인이 필요한 서비스 입니다.", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러가기", secondaryButtonTitle: "계속 둘러보기") {
                                
                            } secondaryButtonAction: {
                                
                            }
                            .transition(.move(edge: .bottom))

                        }
                    }
                    .ignoresSafeArea()
                }
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
                }
                .overlay {
                    ZStack {
                        if appViewModel.showAlertView {
                            Color(.black).opacity(0.4)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        appViewModel.showAlertView = false
                                        appViewModel.showNeedLoginMessageBox = false
                                    }
                                }
                        }
                        
                        if appViewModel.showNeedLoginMessageBox {
                            MessageBoxView(showMessageBox: $appViewModel.showNeedLoginMessageBox, title: "로그인이 필요한 서비스 입니다.", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러가기", secondaryButtonTitle: "계속 둘러보기") {
                                
                            } secondaryButtonAction: {
                                
                            }
                            .transition(.move(edge: .bottom))

                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    @ViewBuilder
    func navigationBar() -> some View {
        HStack(spacing: 15) {
            Text("세종이의 집")
                .font(.title.bold())
            
            Spacer()
            
            NavigationLink {
                SearchView()
                    .navigationTitle("")
                    .modifier(NavigationColorModifier())
            } label: {
                Label("검색", systemImage: "magnifyingglass")
                    .font(.title)
                    .labelStyle(.iconOnly)
                    .matchedGeometryEffect(id: "검색", in: heroEffect)
            }
            
            NavigationLink {
                CartView()
                    .onAppear(){
                        goodsViewModel.fetchCartGoods(token: loginViewModel.returnToken())
                    }
                    .navigationTitle("장바구니")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
                    .redacted(reason: goodsViewModel.isCartGoodsListLoading ? .placeholder : [])
            } label: {
                Label("장바구니", systemImage: "cart")
                    .font(.title)
                    .labelStyle(.iconOnly)
            }
            
            NavigationLink {
                UserInformationView()
                    .navigationTitle("내 정보")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
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
                    ForEach(goodsViewModel.categoryList) { category in
                        categotyButton(category.categoryName, category: category) {
                            if category.id == 0, category.name == "ALLPRODUCT" {
                                goodsViewModel.fetchGoodsList()
                            } else {
                                goodsViewModel.fetchGoodsListFromCatefory(id: category.id)
                            }
                            
                            withAnimation(.spring()) {
                                currentCategory = category
                            }
                        }
                        .redacted(reason: goodsViewModel.isCategoryLoading ? .placeholder : [])
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
    func categotyButton(_ title: String, category: Category, _ action: @escaping () -> Void) -> some View {
        let isSelected = (category.id == currentCategory.id && category.name == currentCategory.name)
        
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : nil)
                .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                .padding(.bottom)
                .overlay(alignment: .bottom) {
                    if isSelected {
                        Rectangle()
                            .foregroundColor(Color("main-highlight-color"))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "선택", in: heroEffect)
                    }
                }
                .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func goodList() -> some View {
        if #available(iOS 16.0, *) {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(goodsViewModel.goodsList) { item in
                        subGoodsView(item)
                    }
                    .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                }
                .padding(.top)
            }
            .refreshable {
                if currentCategory.id == 0, currentCategory.name == "ALLPRODUCT" {
                    goodsViewModel.fetchGoodsList()
                } else {
                    goodsViewModel.fetchGoodsListFromCatefory(id: currentCategory.id)
                }
                goodsViewModel.fetchCategory(token: loginViewModel.returnToken())
            }
        } else {
            List(goodsViewModel.goodsList) { item in
                subGoodsView(item)
                .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                .listRowSeparatorTint(.clear)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .padding(.top)
            }
            .listStyle(.plain)
            .refreshable {
                if currentCategory.id == 0, currentCategory.name == "ALLPRODUCT" {
                    goodsViewModel.fetchGoodsList()
                } else {
                    goodsViewModel.fetchGoodsListFromCatefory(id: currentCategory.id)
                }
                goodsViewModel.fetchCategory(token: loginViewModel.returnToken())
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
                                Color("main-shape-bkg-color")
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                ProgressView()
                                    .tint(Color("main-highlight-color"))
                            }
                        }
                        .frame(width: 115, height: 115)
                        .shadow(radius: 1)
                    } else {
                        Color("main-shape-bkg-color")
                            .frame(width: 115, height: 115)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1)
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
        HomeView()
            .environmentObject(AppViewModel())
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
    }
}
