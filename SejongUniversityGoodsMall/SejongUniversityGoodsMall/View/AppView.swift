//
//  AppView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI



struct AppView: View {
    @Namespace var heroTransition
    
    @EnvironmentObject var sampleGoodsViewModel: SampleGoodsViewModel
    
    @State private var selectedTabPage: SelectedTabPage = .home
    
    var body: some View {
        GeometryReader { reader in
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ZStack {
                        switch selectedTabPage {
                            case .home:
                                HomeView()
                                    .navigationTitle("")
                                    .navigationBarHidden(true)
                            case .shoppingCart:
                                VStack{}
                            case .myInformation:
                                VStack{}
                        }
                        
                        VStack {
                            Spacer()
                            
                            TabBarView(selectedItem: $selectedTabPage)
                                .coordinateSpace(name: "TabBar")
                        }
                    }
                }
                .tint(Color("main-text-color"))
            } else {
                NavigationView {
                    ZStack {
                        switch selectedTabPage {
                            case .home:
                                HomeView()
                                    .navigationTitle("")
                                    .navigationBarHidden(true)
                            case .shoppingCart:
                                VStack{}
                            case .myInformation:
                                VStack{}
                        }
                        
                        VStack {
                            Spacer()
                            
                            TabBarView(selectedItem: $selectedTabPage)
                                .coordinateSpace(name: "TabBar")
                        }
                    }
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(SampleGoodsViewModel())
    }
}
