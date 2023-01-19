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
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                HomeView()
                    .offset(y: reader.safeAreaInsets.top)
                
                VStack {
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
                    .frame(height: reader.safeAreaInsets.magnitude)
                    
                    Spacer()
                }
                .frame(width: reader.size.width, height: reader.safeAreaInsets.magnitude + reader.safeAreaInsets.bottom)
                .background {
                    Rectangle()
                        .foregroundColor(.white)
                        .shadow(color: .gray.opacity(0.3), radius: 3)
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
            }
            .foregroundColor(isSelected ? Color("main-highlight-color") : Color("secondary-text-color"))
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
