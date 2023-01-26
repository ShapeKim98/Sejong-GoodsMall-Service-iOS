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
    @Environment(\.dismiss) var dismiss
    
    private let goods: SampleGoodsModel
    
    @State var service: Servie = .goodsInformation
    @State var showOptionSheet: Bool = false
    @State var imagePage: Int = 1
    @State var optionSheetDrag: CGFloat = .zero
    @State var isOptionSelected: Bool = false
    
    init(goods: SampleGoodsModel) {
        self.goods = goods
        
        if #available(iOS 16.0, *) {

        } else {
            Self.navigationBarColors(background: .white, titleColor: UIColor(Color("main-text-color")))
        }
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack {
                        VStack(spacing: 10) {
                            imageView(height: reader.size.width)
                            
                            nameAndTagView()
                        }
                        .padding(.bottom)
                        
                        goodsInformationView()
                    }
                }
                
                if showOptionSheet {
                    VStack {
                        Spacer()
                        
                        OptionSheetView(isOptionSelected: $isOptionSelected, currentGoods: goods)
                            .frame(width: reader.size.width, height: reader.size.height - reader.size.width + 5)
                    }
                    .coordinateSpace(name: "Contents")
                    .transition(.move(edge: .bottom))
                    .offset(y: optionSheetDrag)
                    .gesture(
                        DragGesture()
                            .onChanged({ drag in
                                optionSheetDrag = drag.translation.height > 0 ? drag.translation.height : drag.translation.height / 10
                            })
                            .onEnded({ drag in
                                withAnimation(.spring()) {
                                    if optionSheetDrag > 100 {
                                        optionSheetDrag = .zero
                                        showOptionSheet = false
                                    } else {
                                        optionSheetDrag = .zero
                                    }
                                }
                            })
                    )
                }
                
                if !isOptionSelected {
                    VStack {
                        Spacer()
                        
                        PurchaseBarView(showOptionSheet: $showOptionSheet, selectedGoods: goods)
                            .frame(height: 53)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .foregroundColor(Color("main-text-color"))
                }
            }
        }
    }
    
    @ViewBuilder
    func imageView(height: CGFloat) -> some View {
        TabView(selection: $imagePage) {
            ForEach(1..<9) { page in
                Image(goods.image)
                    .resizable()
                    .scaledToFit()
                    .tag(page)
            }
        }
        .frame(height: height)
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        HStack(spacing: 0) {
            Text("\(imagePage) ")
                .foregroundColor(Color("main-text-color"))
            Text("/ 8")
                .foregroundColor(Color("secondary-text-color"))
            
            Spacer()
        }
        .font(.system(size: 13))
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func nameAndTagView() -> some View {
        HStack {
            Text(goods.name)
                .font(.system(size: 25).bold())
                .foregroundColor(Color("main-text-color"))
                .padding(.horizontal, 5)
            Spacer()
        }
        .padding(.horizontal)
        
        HStack {
            ForEach(goods.tag, id: \.hashValue) {
                Text($0)
                    .font(.system(size: 10))
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
    
    @ViewBuilder
    func goodsInformationView() -> some View {
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
    
    @ViewBuilder
    func serviceButton(_ title: String, _ seleted: Servie, _ action: @escaping () -> Void) -> some View {
        let isSelected = service == seleted
        
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.system(size: 15))
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
                .font(.system(size: 12))
                .fontWeight(.bold)
                .foregroundColor(Color("main-text-color"))
            
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
    
    static func navigationBarColors(background : UIColor?, titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}



struct Previews_GoodsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GoodsDetailView(goods: SampleGoodsModel(name: "학과 잠바", price: 85_000, image: "sample-image1", tag: ["#새내기", "#종이"], category: .clothing))
    }
}
