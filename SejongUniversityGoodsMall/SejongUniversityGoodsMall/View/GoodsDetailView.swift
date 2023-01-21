//
//  GoodsDetailView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

enum Servie {
    case goodsInformation
    case goodsReview
    case contactUs
}

struct GoodsDetailView: View {
    @Binding var showDetailView: Bool
    
    @State var heroTransition: Namespace.ID
    @State var goods: SampleGoodsModel
    @State var service: Servie = .goodsInformation
    @State var isDetailView: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                HStack {
                    Button {
                        withAnimation(.spring()) {
                            isDetailView = false
                            showDetailView = false
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                    }
                    .foregroundColor(Color("main-text-color"))
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .foregroundColor(Color("main-text-color"))
                }
                .padding()
                
                ScrollView {
                    VStack {
                        VStack(spacing: 10) {
                            Image(goods.image)
                                .resizable()
                                .scaledToFit()
                                .matchedGeometryEffect(id: "\(goods.name)\(goods.image)", in: heroTransition)
                            
                            HStack(spacing: 0) {
                                Text("1 ")
                                    .foregroundColor(Color("main-text-color"))
                                Text("/ 8")
                                    .foregroundColor(Color("secondary-text-color"))
                                
                                Spacer()
                            }
                            .font(.footnote)
                            .padding(.horizontal)
                            
                            HStack {
                                Text(goods.name)
                                    .font(isDetailView ? .title.bold() : nil)
                                    .padding(.horizontal, 5)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack {
                                ForEach(goods.tag, id: \.hashValue) {
                                    Text($0)
                                        .font(.caption2)
                                        .foregroundColor(Color("main-text-color"))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background {
                                            RoundedRectangle(cornerRadius: 40)
                                                .foregroundColor(Color("shape-bkg-color"))
                                        }
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.horizontal, 5)
                        }
                        .padding(.bottom)
                        
                        Rectangle()
                            .foregroundColor(Color("shape-bkg-color"))
                            .frame(height: 10)
                        
                        HStack {
                            serviceButton("상품정보", .goodsInformation) {
                                withAnimation {
                                    service = .goodsInformation
                                }
                            }
                            
                            Spacer()
                            
                            serviceButton("상품후기", .goodsReview) {
                                withAnimation {
                                    service = .goodsReview
                                }
                            }
                            
                            Spacer()
                            
                            serviceButton("문의하기", .contactUs) {
                                withAnimation {
                                    service = .contactUs
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.horizontal)
                        .background {
                            VStack {
                                Spacer()
                                
                                Rectangle()
                                    .foregroundColor(Color("shape-bkg-color"))
                                    .frame(height: 1)
                            }
                        }
                        
                        switch service {
                            case .goodsInformation:
                                goodsInformationPage()
                            case .goodsReview:
                                goodReviewPage()
                            case .contactUs:
                                contactUsPage()
                        }
                        
                        
                    }
                }
            }
            .background(.white)
            .onAppear() {
                isDetailView = true
            }
        }
    }
    
    @ViewBuilder
    func serviceButton(_ title: String, _ seleted: Servie, _ action: @escaping () -> Void) -> some View {
        let isSelected = service == seleted
        
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                    .padding(.horizontal, 0)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 0, height: 3)
            }
            .background {
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(isSelected ? Color("main-highlight-color") : .clear)
                        .frame(height: 3)
                }
            }
        }
    }
    
    @ViewBuilder
    func goodsInformationPage() -> some View {
        HStack {
            Text(goods.goodsInfo)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding()
        .padding(.horizontal, 5)
    }
    
    @ViewBuilder
    func goodReviewPage() -> some View {
        
    }
    
    @ViewBuilder
    func contactUsPage() -> some View {
        
    }
}
