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
                            imageView(height: reader.size.width)
                            
                            nameAndPriceView()
                        }
                        .padding(.bottom)
                        
                        goodsInformationView()
                    }
                }
                
                if showOptionSheet {
                    VStack {
                        Spacer()
                        
                        OptionSheetView(isOptionSelected: $isOptionSelected)
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
                                        isOptionSelected = false
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
                        
                        PurchaseBarView(showOptionSheet: $showOptionSheet)
                            .frame(height: 53)
                    }
                }
            }
            .navigationBarBackButtonHidden(isExtendedImage)
            .onDisappear() {
                goodsViewModel.goodsDetail = Goods(id: 0, categoryID: nil, title: "loading...", color: nil, size: nil, price: 99999, goodsImages: [], goodsInfos: [], description: "loading...")
            }
            .overlay {
                if isExtendedImage {
                    ZStack {
                        Color(.black)
                            .opacity(1.0 - (extendedImageOffset / 500))
                        
                        extendedImageView()
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    @ViewBuilder
    func imageView(height: CGFloat) -> some View {
        TabView(selection: $imagePage) {
            ForEach(goodsViewModel.goodsDetail.goodsImages, id: \.id) { image in
                AsyncImage(url: URL(string: image.oriImgName)) { img in
                    if !isExtendedImage {
                        img
                            .resizable()
                            .scaledToFit()
                            .frame(width: height, height: height)
                            .matchedGeometryEffect(id: "\(image.oriImgName)", in: heroEffect)
                    }
                } placeholder: {
                    ZStack {
                        Image("sample-image1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: height, height: height)
                            .redacted(reason: .placeholder)
                        ProgressView()
                            .tint(Color("main-highlight-color"))
                    }
                }
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
        
        HStack(spacing: 0) {
            Text("\(imagePage) ")
                .foregroundColor(Color("main-text-color"))
            Text("/ \(goodsViewModel.goodsDetail.goodsImages.count)")
                .foregroundColor(Color("secondary-text-color"))
            
            Spacer()
        }
        .font(.footnote)
        .padding(.horizontal)
    }
    
    @State private var isExtendedImage: Bool = false
    @State private var extendedImageOffset: CGFloat = .zero
    
    @ViewBuilder
    func extendedImageView() -> some View {
        TabView(selection: $imagePage) {
            ForEach(goodsViewModel.goodsDetail.goodsImages, id: \.id) { image in
                AsyncImage(url: URL(string: image.oriImgName)) { img in
                    img
                        .resizable()
                        .scaledToFit()
                        .matchedGeometryEffect(id: "\(image.oriImgName)", in: heroEffect)
                } placeholder: {
                    ZStack {
                        Image("sample-image1")
                            .resizable()
                            .scaledToFit()
                            .redacted(reason: .placeholder)
                        ProgressView()
                            .tint(Color("main-highlight-color"))
                    }
                }
                .tag(image.id - goodsViewModel.goodsDetail.id)
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
        LazyVStack {
            ForEach(goodsViewModel.goodsDetail.goodsInfos, id: \.infoURL) { info in
                AsyncImage(url: URL(string: info.infoURL, relativeTo: APIURL.server.url()))
            }
        }
    }
    
    @ViewBuilder
    func goodReviewPage() -> some View {
        
    }
    
    @ViewBuilder
    func contactUsPage() -> some View {
        
    }
}

struct Previews_GoodsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GoodsDetailView()
            .environmentObject(GoodsViewModel())
    }
}
