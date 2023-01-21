//
//  AppView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI



struct AppView: View {
    @Namespace var heroTransition
    
    @State private var selectedTabPage: SelectedTabPage = .home
    @State var selectedGoods: SampleGoodsModel?
    @State private var showDetailView: Bool = false
    
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                switch selectedTabPage {
                    case .home:
                        HomeView(showDetailView: $showDetailView, selectedGoods: $selectedGoods, heroTransition: heroTransition)
                    case .shoppingCart:
                        VStack{}
                    case .myInformation:
                        VStack{}
                }
                
                VStack {
                    Spacer()
                    
                    if let goods = selectedGoods, showDetailView {
                        PurchaseBarView(selectedGoods: goods)
                            .coordinateSpace(name: "TabBar")
                            .onDisappear() {
                                selectedGoods = nil
                            }
                    } else {
                        TabBarView(selectedItem: $selectedTabPage)
                            .coordinateSpace(name: "TabBar")
                    }
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
