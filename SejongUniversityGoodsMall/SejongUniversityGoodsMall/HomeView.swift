//
//  HomeView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

enum Category {
    case allProduct
    case phrases
    case clothing
    case badgeAndKeyring
    case forGift
}

struct HomeView: View {
    @State private var searchText = ""
    @State private var category: Category = .allProduct
    
    var body: some View {
        GeometryReader { reader in
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
                                }
                            }
                            
                            categotyButton("문구", .phrases) {
                                withAnimation {
                                    category = .phrases
                                }
                            }
                            
                            categotyButton("의류", .clothing) {
                                withAnimation {
                                    category = .clothing
                                }
                            }
                            
                            categotyButton("뱃지&키링", .badgeAndKeyring) {
                                withAnimation {
                                    category = .badgeAndKeyring
                                }
                            }
                            
                            categotyButton("선물용", .forGift) {
                                withAnimation {
                                    category = .forGift
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
