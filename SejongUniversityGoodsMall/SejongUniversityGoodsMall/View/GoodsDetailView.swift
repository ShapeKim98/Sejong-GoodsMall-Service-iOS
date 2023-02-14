//
//  GoodsDetailView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

struct GoodsDetailView: View {
    enum Servie {
        case goodsInformation
        case goodsReview
        case contactUs
    }
    
    @Namespace var heroEffect
    
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State var service: Servie = .goodsInformation
    @State var showOptionSheet: Bool = false
    @State var imagePage: Int = 1
    @State var optionSheetDrag: CGFloat = .zero
    @State var isOptionSelected: Bool = false
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                ScrollView {
                    VStack {
                        VStack(spacing: 10) {
                            if !isExtendedImage {
                                imageView(height: reader.size.width)
                                    .matchedGeometryEffect(id: "이미지", in: heroEffect)
                                    .unredacted()
                            } else {
                                Color("shape-bkg-color")
                                    .frame(width: reader.size.width, height: reader.size.width)
                            }
                            
                            HStack(spacing: 0) {
                                Text("\(imagePage) ")
                                    .foregroundColor(Color("main-text-color"))
                                Text("/ \(goodsViewModel.goodsDetail.goodsImages.count)")
                                    .foregroundColor(Color("secondary-text-color"))
                                
                                Spacer()
                            }
                            .font(.footnote)
                            .padding(.horizontal)
                            
                            nameAndPriceView()
                        }
                        .padding(.bottom)
                        
                        Rectangle()
                            .foregroundColor(Color("shape-bkg-color"))
                            .frame(height: 10)
                        
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
            .navigationBarBackButtonHidden(isExtendedImage)
            .onDisappear() {
                goodsViewModel.goodsDetail = Goods(id: 0, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading...")
                goodsViewModel.cartRequest.removeAll()
            }
            .overlay(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    if showOptionSheet {
                        VStack(spacing: 0) {
                            LinearGradient(colors: [.black.opacity(0),
                                                    .black.opacity(0.1),
                                                    .black.opacity(0.2),
                                                    .black.opacity(0.3)
                            ], startPoint: .top, endPoint: .bottom)
                            .frame(height: 5)
                            .opacity(0.3)
                            
                            OptionSheetView(isOptionSelected: $isOptionSelected)
                                .frame(minHeight: reader.size.height - reader.size.width + 5)
                                .background(.white)
                                .transition(.move(edge: .bottom))
                        }
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
                                            isOptionSelected = false
                                        } else {
                                            optionSheetDrag = .zero
                                        }
                                    }
                                })
                        )
                        
                    }
                    
                    if !isOptionSelected {
                        PurchaseBarView(showOptionSheet: $showOptionSheet)
                    }
                    
                    
                    if isExtendedImage {
                        ZStack {
                            Color(.black)
                                .opacity(1.0 - (extendedImageOffset / 500))
                            
                            extendedImageView(width: reader.size.width)
                                .matchedGeometryEffect(id: "이미지", in: heroEffect)
                                .unredacted()
                        }
                        .ignoresSafeArea()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func imageView(height: CGFloat) -> some View {
        TabView(selection: $imagePage) {
            ForEach(goodsViewModel.goodsDetail.goodsImages, id: \.id) { image in
                AsyncImage(url: URL(string: image.oriImgName)) { img in
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(width: height, height: height)
                } placeholder: {
                    ZStack {
                        Color("shape-bkg-color")
                        
                        ProgressView()
                            .tint(Color("main-highlight-color"))
                    }
                }
                .frame(width: height, height: height)
                .tag(image.id - goodsViewModel.goodsDetail.id)
                .onTapGesture {
                    withAnimation(.spring()) {
                        isExtendedImage = true
                    }
                }
            }
        }
        .frame(height: height)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    @State private var isExtendedImage: Bool = false
    @State private var extendedImageOffset: CGFloat = .zero
    
    @ViewBuilder
    func extendedImageView(width: CGFloat) -> some View {
        TabView(selection: $imagePage) {
            ForEach(goodsViewModel.goodsDetail.goodsImages, id: \.id) { image in
                AsyncImage(url: URL(string: image.oriImgName)) { img in
                    img
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ZStack {
                        Color("main-shape-bkg-color")
                        
                        ProgressView()
                            .tint(Color("main-highlight-color"))
                    }
                }
                .frame(width: width)
                .tag(image.id - goodsViewModel.goodsDetail.id)
            }
            .overlay {
                HStack {
                    if imagePage != 1 {
                        Button {
                            withAnimation {
                                imagePage -= 1
                            }
                        } label: {
                            Label("이전페이지", systemImage: "chevron.compact.left")
                                .font(.largeTitle.bold())
                                .labelStyle(.iconOnly)
                                .foregroundColor(Color("main-text-color").opacity(0.7))
                                .padding()
                        }
                        .shadow(radius: 15)
                        
                    }
                    
                    Spacer()
                    
                    if imagePage != goodsViewModel.goodsDetail.goodsImages.count {
                        Button {
                            withAnimation {
                                imagePage += 1
                            }
                        } label: {
                            Label("다음페이지", systemImage: "chevron.compact.right")
                                .font(.largeTitle.bold())
                                .labelStyle(.iconOnly)
                                .foregroundColor(Color("main-text-color").opacity(0.7))
                                .padding()
                        }
                        .shadow(radius: 15)
                    }
                }
            }
            .opacity(1.0 - (extendedImageOffset / 500))
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .offset(y: extendedImageOffset)
        .gesture(
            DragGesture()
                .onChanged({ drag in
                    extendedImageOffset = drag.translation.height
                })
                .onEnded({ drag in
                    if extendedImageOffset > 100 || extendedImageOffset < -100 {
                        withAnimation(.spring()) {
                            isExtendedImage = false
                        }
                    }
                    
                    extendedImageOffset = .zero
                })
        )
    }
    
    @ViewBuilder
    func nameAndPriceView() -> some View {
        HStack {
            Text(goodsViewModel.goodsDetail.title)
                .font(.title2.bold())
                .foregroundColor(Color("main-text-color"))
                .padding(.horizontal, 5)
            Spacer()
        }
        .padding(.horizontal)
        
        HStack {
            Text("\(goodsViewModel.goodsDetail.price)원")
                .font(.title.bold())
                .foregroundColor(Color("main-text-color"))
                .padding(.horizontal, 5)
            Spacer()
        }
        .padding(.horizontal)
        
    }
    
    @ViewBuilder
    func goodsInformationView() -> some View {
        VStack {
            HStack {
                serviceButton("상품정보", .goodsInformation) {
                    withAnimation(.spring()) {
                        service = .goodsInformation
                    }
                }
                
                Spacer()
                
                serviceButton("상품후기", .goodsReview) {
                    withAnimation(.spring()) {
                        service = .goodsReview
                    }
                }
                
                Spacer()
                
                serviceButton("문의하기", .contactUs) {
                    withAnimation(.spring()) {
                        service = .contactUs
                    }
                }
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .padding(.top, 10)
            .background {
                VStack {
                    Spacer()
                    
                    Rectangle()
                        .foregroundColor(Color("shape-bkg-color"))
                        .frame(height: 1)
                }
            }
        }
        .background(.white)
    }
    
    @ViewBuilder
    func serviceButton(_ title: String, _ seleted: Servie, _ action: @escaping () -> Void) -> some View {
        let isSelected = service == seleted
        
        Button(action: action) {
            VStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .bold : .light)
                    .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                    .padding(.horizontal, 0)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 0, height: 3)
            }
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .foregroundColor(Color("main-highlight-color"))
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "선택", in: heroEffect)
                }
            }
        }
    }
    
    @ViewBuilder
    func goodsInformationPage() -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                ForEach(goodsViewModel.goodsDetail.goodsInfos, id: \.infoURL) { info in
                    AsyncImage(url: URL(string: info.infoURL.replacingOccurrences(of: "/images/info/", with: ""))) { image in
                        image
                            .resizable()
                            .scaledToFit()
                        
                    } placeholder: {
                        ZStack {
                            Color("main-shape-bkg-color")
                            
                            ProgressView()
                                .tint(Color("main-highlight-color"))
                        }
                    }
                }
            } header: {
                goodsInformationView()
            }
        }
    }
    
    @ViewBuilder
    func goodReviewPage() -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                
            } header: {
                goodsInformationView()
            }
            
        }
    }
    
    @ViewBuilder
    func contactUsPage() -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                
            } header: {
                goodsInformationView()
            }
            
        }
    }
}

struct Previews_GoodsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GoodsDetailView()
            .environmentObject(GoodsViewModel())
    }
}
