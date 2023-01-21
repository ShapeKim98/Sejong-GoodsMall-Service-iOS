//
//  AppView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

enum Page {
    case home
    case shoppingCart
    case myInfo
}

struct AppView: View {
    @Namespace var heroTranstion
    
    @State private var page: Page = .home
    @State private var showDetailView = false
    @State private var selectedGoods: SampleGoodsModel? = nil
    
    var body: some View {
        GeometryReader { reader in
            TabView {
                HomeView(showDetailView: $showDetailView, selectedGoods: $selectedGoods, heroTransition: heroTranstion)
                    .tabItem {
                        Label("홈", systemImage: "house")
                    }
                VStack {
                    
                }
                .tabItem {
                    Label("장바구니", systemImage: "cart")
                }
                
                VStack {
                    
                }
                .tabItem {
                    Label("내정보", systemImage: "person")
                }
            }
            .accentColor(Color("main-highlight-color"))
            .disabled(showDetailView)
            .overlay {
                if let goods = selectedGoods, showDetailView {
                    GoodsDetailView(showDetailView: $showDetailView, heroTransition: heroTranstion, goods: goods)
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
