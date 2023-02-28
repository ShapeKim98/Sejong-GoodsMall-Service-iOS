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
        case sellerInformation
    }
    
    @Namespace var heroEffect
    
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State private var service: Servie = .goodsInformation
    @State private var showOptionSheet: Bool = false
    @State private var imagePage: Int = 1
    @State private var optionSheetDrag: CGFloat = .zero
    @State private var isOptionSelected: Bool = false
    @State private var showHelpAlert: Bool = false
    @State private var vibrateOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = .zero
    
    var body: some View {
        GeometryReader { reader in
            ScrollView {
                VStack {
                    VStack(spacing: 10) {
                        if goodsViewModel.isGoodsDetailLoading {
                            Color("main-shape-bkg-color")
                                .frame(width: reader.size.width, height: reader.size.width - (scrollOffset < 0 ? scrollOffset : 0))
                                .offset(y: scrollOffset < 0 ? scrollOffset : 0)
                                .shadow(radius: 1)
                        } else {
                            imageView(height: reader.size.width)
                                .unredacted()
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
                        case .sellerInformation:
                            sellerInformationPage()
                    }
                }
                .background {
                    GeometryReader { reader in
                        let offset = -reader.frame(in: .named("SCROLL")).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    }
                }
            }
            .coordinateSpace(name: "SCROLL")
            .overlay(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    if showOptionSheet {
                        let isSmallDisplayDevice = UIDevice.current.name == "iPhone 6s" ||
                        UIDevice.current.name == "iPhone 7" ||
                        UIDevice.current.name == "iPhone 8" ||
                        UIDevice.current.name == "iPhone SE" ||
                        UIDevice.current.name == "iPhone SE (2nd generation)" ||
                        UIDevice.current.name == "iPhone SE (3nd generation)"
                        
                        let isMediumDisplayDevice = UIDevice.current.name == "iPhone 6s Plus" || UIDevice.current.name == "iPhone 7 Plus" || UIDevice.current.name == "iPhone 8 Plus"
                        
                        OptionSheetView(isOptionSelected: $isOptionSelected, vibrateOffset: $vibrateOffset)
                            .frame(height: reader.size.height - (isSmallDisplayDevice ? 270 : (isMediumDisplayDevice ? 350 : reader.size.width)) + 5)
                            .transition(.move(edge: .bottom))
                            .offset(y: optionSheetDrag)
                            .gesture(
                                DragGesture()
                                    .onChanged({ drag in
                                        if !isOptionSelected {
                                            optionSheetDrag = drag.translation.height > 0 ? drag.translation.height : drag.translation.height / 10
                                        } else {
                                            optionSheetDrag = drag.translation.height / 10
                                        }
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
                        PurchaseBarView(showOptionSheet: $showOptionSheet, vibrateOffset: $vibrateOffset)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .onDisappear() {
                goodsViewModel.seletedGoods.color = nil
                goodsViewModel.seletedGoods.size = nil
                goodsViewModel.seletedGoods.quantity = 0
            }
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                scrollOffset = value
                print(scrollOffset)
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
                        .scaledToFill()
                        .frame(width: height, height: height - (scrollOffset < 0 ? scrollOffset : 0))
                } placeholder: {
                    ZStack {
                        Color("shape-bkg-color")
                        
                        ProgressView()
                            .tint(Color("main-highlight-color"))
                    }
                }
                .frame(width: height, height: height - (scrollOffset < 0 ? scrollOffset : 0))
                .tag(image.id - goodsViewModel.goodsDetail.id)
            }
        }
        .frame(height: height - (scrollOffset < 0 ? scrollOffset : 0))
        .offset(y: scrollOffset < 0 ? scrollOffset : 0)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    @ViewBuilder
    func nameAndPriceView() -> some View {
        HStack {
            Text(goodsViewModel.goodsDetail.title)
                .font(.title2.bold())
                .foregroundColor(Color("main-text-color"))
                .padding(.horizontal, 5)
            
            Spacer()
            
            Button {
                showHelpAlert = true
            } label: {
                Label("도움말", systemImage: "info.circle")
                    .font(.title3)
                    .labelStyle(.iconOnly)
                    .foregroundColor(Color("point-color"))
            }
            .alert("도움말", isPresented: $showHelpAlert) {
                Button {
                    showHelpAlert = false
                } label: {
                   Text("확인")
                }
                .foregroundColor(Color("main-highlight-color"))

            } message: {
                Text("현장 수령 선택시 현장에서만 결제 가능하고,\n택배 수령 선택시 무통장 입금만 결제 가능합니다.")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
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
        HStack {
            Spacer()
            
            serviceButton("상품정보", .goodsInformation) {
                withAnimation(.spring()) {
                    service = .goodsInformation
                }
            }
            
            Spacer(minLength: 120)
            
            serviceButton("판매자 정보", .sellerInformation) {
                withAnimation(.spring()) {
                    service = .sellerInformation
                }
            }
            
            Spacer()
        }
        .padding(.top, 10)
        .background(alignment: .bottom) {
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
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
                    .padding(.bottom, 10)
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
    func sellerInformationPage() -> some View {
        LazyVStack(pinnedViews: [.sectionHeaders]) {
            Section {
                
            } header: {
                goodsInformationView()
            }
            
        }
    }
}

struct GoodsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GoodsDetailView()
            .environmentObject(GoodsViewModel())
            .environmentObject(LoginViewModel())
            .environmentObject(AppViewModel())
    }
}
