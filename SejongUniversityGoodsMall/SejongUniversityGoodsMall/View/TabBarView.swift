//
//  TabBarView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/21.
//

import SwiftUI



struct TabBarView: View {
    @Binding var selectedItem: SelectedTabPage

    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.black.opacity(0),
                                    .black.opacity(0.1),
                                    .black.opacity(0.2),
                                    .black.opacity(0.3)
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 5)
            .opacity(0.3)
            .background(.clear)
            
                tabItems()
        }
        .background(.clear)
    }
    
    func tabItems() -> some View {
            HStack {
                Button {
                    withAnimation {
                        selectedItem = .home
                    }
                } label: {
                    VStack {
                        Image(systemName: "house")
                            .font(.title2)
                        
                        Text("홈")
                            .font(.caption)
                    }
                    .foregroundColor(selectedItem == .home ? Color("main-highlight-color") : Color("secondary-text-color"))
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        selectedItem = .shoppingCart
                    }
                } label: {
                    VStack {
                        Image(systemName: "cart")
                            .font(.title2)
                        
                        Text("장바구니")
                            .font(.caption)
                    }
                    .foregroundColor(selectedItem == .shoppingCart ? Color("main-highlight-color") : Color("secondary-text-color"))
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        selectedItem = .myInformation
                    }
                } label: {
                    VStack {
                        Image(systemName: "person")
                            .font(.title2)
                        
                        Text("내정보")
                            .font(.caption)
                    }
                    .foregroundColor(selectedItem == .myInformation ? Color("main-highlight-color") : Color("secondary-text-color"))
                }
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 50)
            .background(.white)
    }
}
