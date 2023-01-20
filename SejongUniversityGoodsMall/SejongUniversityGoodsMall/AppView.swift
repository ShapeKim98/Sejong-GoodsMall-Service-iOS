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
    @State private var page: Page = .home
    @State private var showDetailView: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                HomeView(showDetailView: $showDetailView)
                    .offset(y: reader.safeAreaInsets.top)
                
                if showDetailView {
                    
                } else {
                    tabBar(reader: reader)
                        .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    func tabBarButton(_ title: String, icon: String, selected: Page, _ action: @escaping () -> Void) -> some View {
        let isSelected = page == selected
        
        Button(action: action) {
            VStack {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                
                Text(title)
                    .font(.caption)
                
                Spacer()
            }
            .foregroundColor(isSelected ? Color("main-highlight-color") : Color("secondary-text-color"))
        }
    }
    
    @ViewBuilder
    func tabBar(reader: GeometryProxy) -> some View {
        HStack {
            Spacer()
            
            tabBarButton("홈", icon: "home-icon", selected: .home) {
                withAnimation {
                    page = .home
                }
            }
            
            Spacer()
            
            tabBarButton("장바구니", icon: "shopping-cart-icon", selected: .shoppingCart) {
                withAnimation {
                    page = .shoppingCart
                }
            }
            
            Spacer()
            
            tabBarButton("내정보", icon: "my-info-icon", selected: .myInfo) {
                withAnimation {
                    page = .myInfo
                }
            }
            
            Spacer()
        }
        .background {
            Rectangle()
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(0.3), radius: 3)
                .frame(width: reader.size.width, height: 83)
        }
        .padding(.top)
        .frame(width: reader.size.width, height: 83)
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
