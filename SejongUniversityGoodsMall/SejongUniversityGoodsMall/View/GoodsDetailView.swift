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
    
    @Environment(\.dismiss) var dismiss
    
    @Namespace var heroEffect
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var service: Servie = .goodsInformation
    @State private var showOptionSheet: Bool = false
    @State private var imagePage: Int = 1
    @State private var optionSheetDrag: CGFloat = .zero
    @State private var isOptionSelected: Bool = false
    @State private var showHelpAlert: Bool = false
    @State private var vibrateOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = .zero
    @State private var isWished: Bool = false
    
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
                            .frame(height: reader.size.height - (isSmallDisplayDevice ? 220 : (isMediumDisplayDevice ? 300 : reader.size.width)) + 5)
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
                        purchaseBar()
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .fullScreenCover(isPresented: $goodsViewModel.showOrderView) {
                NavigationView {
                    OrderView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    goodsViewModel.showOrderView = false
                                } label: {
                                    Label("닫기", systemImage: "xmark")
                                        .labelStyle(.iconOnly)
                                        .font(.footnote)
                                        .foregroundColor(Color("main-text-color"))
                                }
                            }
                        }
                        .onAppear() {
                            goodsViewModel.orderGoods.append(OrderItem(color: goodsViewModel.seletedGoods.color, size: goodsViewModel.seletedGoods.size, quantity: goodsViewModel.seletedGoods.quantity, price: goodsViewModel.goodsDetail.price * goodsViewModel.seletedGoods.quantity))
                        }
                }
            }
            .fullScreenCover(isPresented: $goodsViewModel.isOrderComplete) {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        OrderCompleteView {
                            dismiss()
                            goodsViewModel.isOrderComplete = false
                        }
                    }
                } else {
                    NavigationView {
                        OrderCompleteView {
                            dismiss()
                            goodsViewModel.isOrderComplete = false
                        }
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
                Group {
                    switch goodsViewModel.goodsDetail.seller.method {
                        case .both:
                            Text("현장 수령 선택시 현장에서만 수령 가능하고\n배송 수령 선택시 배송비가 별도로 부과됩니다.")
                                .font(.caption)
                                .fontWeight(.semibold)
                        case .pickUp:
                            Text("본 상품은 현장 수령만 가능합니다.\n현장 수령만 가능하니 잘 생각하고 주문해주세요.")
                                .font(.caption)
                                .fontWeight(.semibold)
                        case .delivery:
                            Text("본 상품은 택배 수령만 가능합니다.\n택배 수령만 가능하니 잘 생각하고 주문해주세요.")
                                .font(.caption)
                                .fontWeight(.semibold)
                    }
                }
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
    
    @ViewBuilder
    func purchaseBar() -> some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.black.opacity(0),
                                    .black.opacity(0.1),
                                    .black.opacity(0.2),
                                    .black.opacity(0.3)
            ], startPoint: .top, endPoint: .bottom)
            .frame(height: 5)
            .opacity(0.3)
            .background(.clear)
            
            HStack(spacing: 20) {
                ZStack {
                    if !showOptionSheet {
                        Button {
                            withAnimation {
                                isWished.toggle()
                            }
                        } label: {
                            VStack(spacing: 0) {
                                if isWished {
                                    Image(systemName: "heart.fill")
                                        .font(.title2)
                                        .foregroundColor(Color("main-highlight-color"))
                                } else {
                                    Image(systemName: "heart")
                                        .font(.title2)
                                }
                                
                                Text("찜하기")
                                    .font(.caption2)
                            }
                        }
                        .foregroundColor(Color("main-text-color"))
                    }
                    
                    Button {
                        if !loginViewModel.isAuthenticate {
                            appViewModel.messageBoxTitle = "로그인이 필요한 서비스 입니다"
                            appViewModel.messageBoxSecondaryTitle = "로그인 하시겠습니까?"
                            appViewModel.messageBoxMainButtonTitle = "로그인 하러 가기"
                            appViewModel.messageBoxSecondaryButtonTitle = "계속 둘러보기"
                            appViewModel.messageBoxMainButtonAction = {
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                                
                                loginViewModel.showLoginView = true
                            }
                            appViewModel.messageBoxSecondaryButtonAction = {
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                            }
                            appViewModel.messageBoxCloseButtonAction = {
                                appViewModel.messageBoxTitle = ""
                                appViewModel.messageBoxSecondaryTitle = ""
                                appViewModel.messageBoxMainButtonTitle = ""
                                appViewModel.messageBoxSecondaryButtonTitle = ""
                                appViewModel.messageBoxMainButtonAction = {}
                                appViewModel.messageBoxSecondaryButtonAction = {}
                                appViewModel.messageBoxCloseButtonAction = {}
                                
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                            }
                            
                            
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = true
                                appViewModel.showMessageBox = true
                                
                            }
                        } else {
                            if goodsViewModel.isSendGoodsPossible {
                                if goodsViewModel.goodsDetail.seller.method == .both {
                                    appViewModel.messageBoxTitle = "담을 방법을 선택해 주세요"
                                    appViewModel.messageBoxSecondaryTitle = "현장 수령 선택시 현장에서만 수령 가능하고\n배송 수령 선택시 배송비가 별도로 부과됩니다."
                                    appViewModel.messageBoxMainButtonTitle = "현장 수령하기"
                                    appViewModel.messageBoxSecondaryButtonTitle = "택배 수령하기"
                                    appViewModel.messageBoxMainButtonAction = {
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                        
                                        withAnimation {
                                            goodsViewModel.seletedGoods.cartMethod = .pickUpOrder
                                            goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                                            goodsViewModel.seletedGoods.quantity = 0
                                            goodsViewModel.seletedGoods.color = nil
                                            goodsViewModel.seletedGoods.size = nil
                                        }
                                    }
                                    appViewModel.messageBoxSecondaryButtonAction = {
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                        
                                        withAnimation {
                                            goodsViewModel.seletedGoods.cartMethod = .deliveryOrder
                                            goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                                            goodsViewModel.seletedGoods.quantity = 0
                                            goodsViewModel.seletedGoods.color = nil
                                            goodsViewModel.seletedGoods.size = nil
                                        }
                                    }
                                    appViewModel.messageBoxCloseButtonAction = {
                                        appViewModel.messageBoxTitle = ""
                                        appViewModel.messageBoxSecondaryTitle = ""
                                        appViewModel.messageBoxMainButtonTitle = ""
                                        appViewModel.messageBoxSecondaryButtonTitle = ""
                                        appViewModel.messageBoxMainButtonAction = {}
                                        appViewModel.messageBoxSecondaryButtonAction = {}
                                        appViewModel.messageBoxCloseButtonAction = {}
                                        
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                    }
                                    
                                    withAnimation(.spring()) {
                                        appViewModel.showMessageBoxBackground = true
                                        appViewModel.showMessageBox = true
                                    }
                                } else {
                                    appViewModel.messageBoxTitle = goodsViewModel.goodsDetail.seller.method == .pickUp ? "본 상품은 현장 수령만 가능합니다." : "본 상품은 택배 수령만 가능합니다."
                                    appViewModel.messageBoxSecondaryTitle = goodsViewModel.goodsDetail.seller.method == .pickUp ? "현장 수령만 가능하니 잘 생각하고 담아주세요" : "택배 수령만 가능하니 잘 생각하고 담아주세요."
                                    appViewModel.messageBoxMainButtonTitle = goodsViewModel.goodsDetail.seller.method == .pickUp ? "현장 수령하기" : "택배 수령하기"
                                    appViewModel.messageBoxSecondaryButtonTitle = "둘러보기"
                                    appViewModel.messageBoxMainButtonAction = {
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                        
                                        withAnimation {
                                            goodsViewModel.seletedGoods.cartMethod = goodsViewModel.goodsDetail.seller.method == .pickUp ? .pickUpOrder : .deliveryOrder
                                            goodsViewModel.sendCartGoodsRequest(token: loginViewModel.returnToken())
                                            goodsViewModel.seletedGoods.quantity = 0
                                            goodsViewModel.seletedGoods.color = nil
                                            goodsViewModel.seletedGoods.size = nil
                                        }
                                    }
                                    appViewModel.messageBoxSecondaryButtonAction = {
                                        appViewModel.messageBoxTitle = ""
                                        appViewModel.messageBoxSecondaryTitle = ""
                                        appViewModel.messageBoxMainButtonTitle = ""
                                        appViewModel.messageBoxSecondaryButtonTitle = ""
                                        appViewModel.messageBoxMainButtonAction = {}
                                        appViewModel.messageBoxSecondaryButtonAction = {}
                                        appViewModel.messageBoxCloseButtonAction = {}
                                        
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                    }
                                    appViewModel.messageBoxCloseButtonAction = {
                                        appViewModel.messageBoxTitle = ""
                                        appViewModel.messageBoxSecondaryTitle = ""
                                        appViewModel.messageBoxMainButtonTitle = ""
                                        appViewModel.messageBoxSecondaryButtonTitle = ""
                                        appViewModel.messageBoxMainButtonAction = {}
                                        appViewModel.messageBoxSecondaryButtonAction = {}
                                        appViewModel.messageBoxCloseButtonAction = {}
                                        
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                    }
                                    
                                    withAnimation(.spring()) {
                                        appViewModel.showMessageBoxBackground = true
                                        appViewModel.showMessageBox = true
                                    }
                                }
                            } else {
                                withAnimation(.spring()) {
                                    vibrateOffset += 1
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("장바구니 담기")
                                .font(.subheadline.bold())
                                .foregroundColor(Color("main-highlight-color"))
                                .padding(.vertical)
                            
                            Spacer()
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("main-highlight-color"))
                    }
                    .frame(width: showOptionSheet ? nil : 30)
                    .opacity(showOptionSheet ? 1 : 0)
                    .disabled(!showOptionSheet)
                }
                
                if showOptionSheet {
                    Button {
                        if !loginViewModel.isAuthenticate {
                            appViewModel.messageBoxTitle = "로그인이 필요한 서비스 입니다"
                            appViewModel.messageBoxSecondaryTitle = "로그인 하시겠습니까?"
                            appViewModel.messageBoxMainButtonTitle = "로그인 하러 가기"
                            appViewModel.messageBoxSecondaryButtonTitle = "계속 둘러보기"
                            appViewModel.messageBoxMainButtonAction = {
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                                
                                loginViewModel.showLoginView = true
                            }
                            appViewModel.messageBoxSecondaryButtonAction = {
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                            }
                            appViewModel.messageBoxCloseButtonAction = {
                                appViewModel.messageBoxTitle = ""
                                appViewModel.messageBoxSecondaryTitle = ""
                                appViewModel.messageBoxMainButtonTitle = ""
                                appViewModel.messageBoxSecondaryButtonTitle = ""
                                appViewModel.messageBoxMainButtonAction = {}
                                appViewModel.messageBoxSecondaryButtonAction = {}
                                appViewModel.messageBoxCloseButtonAction = {}
                                
                                withAnimation(.spring()) {
                                    appViewModel.showMessageBoxBackground = false
                                    appViewModel.showMessageBox = false
                                }
                            }
                            
                            withAnimation(.spring()) {
                                appViewModel.showMessageBoxBackground = true
                                appViewModel.showMessageBox = true
                                
                            }
                        } else {
                            if goodsViewModel.isSendGoodsPossible {
                                if goodsViewModel.goodsDetail.seller.method == .both {
                                    appViewModel.messageBoxTitle = "주문 방법을 선택해 주세요"
                                    appViewModel.messageBoxSecondaryTitle = "현장 수령 선택시 현장에서만 수령 가능하고\n배송 수령 선택시 배송비가 별도로 부과됩니다."
                                    appViewModel.messageBoxMainButtonTitle = "현장 수령하기"
                                    appViewModel.messageBoxSecondaryButtonTitle = "택배 수령하기"
                                    appViewModel.messageBoxMainButtonAction = {
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                            
                                            goodsViewModel.orderType = .pickUpOrder
                                            goodsViewModel.showOrderView = true
                                        }
                                    }
                                    appViewModel.messageBoxSecondaryButtonAction = {
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                        
                                        goodsViewModel.orderType = .deliveryOrder
                                        goodsViewModel.showOrderView = true
                                    }
                                    appViewModel.messageBoxCloseButtonAction = {
                                        appViewModel.messageBoxTitle = ""
                                        appViewModel.messageBoxSecondaryTitle = ""
                                        appViewModel.messageBoxMainButtonTitle = ""
                                        appViewModel.messageBoxSecondaryButtonTitle = ""
                                        appViewModel.messageBoxMainButtonAction = {}
                                        appViewModel.messageBoxSecondaryButtonAction = {}
                                        appViewModel.messageBoxCloseButtonAction = {}
                                        
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                    }
                                    
                                    withAnimation(.spring()) {
                                        appViewModel.showMessageBoxBackground = true
                                        appViewModel.showMessageBox = true
                                    }
                                } else {
                                    appViewModel.messageBoxTitle = goodsViewModel.goodsDetail.seller.method == .pickUp ? "본 상품은 현장 수령만 가능합니다." : "본 상품은 택배 수령만 가능합니다."
                                    appViewModel.messageBoxSecondaryTitle = goodsViewModel.goodsDetail.seller.method == .pickUp ? "현장 수령만 가능하니 잘 생각하고 주문해주세요." : "택배 수령만 가능하니 잘 생각하고 주문해주세요."
                                    appViewModel.messageBoxMainButtonTitle = goodsViewModel.goodsDetail.seller.method == .pickUp ? "현장 수령하기" : "택배 수령하기"
                                    appViewModel.messageBoxSecondaryButtonTitle = "둘러보기"
                                    appViewModel.messageBoxMainButtonAction = {
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                            
                                            goodsViewModel.orderType = goodsViewModel.goodsDetail.seller.method == .pickUp ? .pickUpOrder : .deliveryOrder
                                            goodsViewModel.showOrderView = true
                                        }
                                    }
                                    appViewModel.messageBoxSecondaryButtonAction = {
                                        appViewModel.messageBoxTitle = ""
                                        appViewModel.messageBoxSecondaryTitle = ""
                                        appViewModel.messageBoxMainButtonTitle = ""
                                        appViewModel.messageBoxSecondaryButtonTitle = ""
                                        appViewModel.messageBoxMainButtonAction = {}
                                        appViewModel.messageBoxSecondaryButtonAction = {}
                                        appViewModel.messageBoxCloseButtonAction = {}
                                        
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                    }
                                    appViewModel.messageBoxCloseButtonAction = {
                                        appViewModel.messageBoxTitle = ""
                                        appViewModel.messageBoxSecondaryTitle = ""
                                        appViewModel.messageBoxMainButtonTitle = ""
                                        appViewModel.messageBoxSecondaryButtonTitle = ""
                                        appViewModel.messageBoxMainButtonAction = {}
                                        appViewModel.messageBoxSecondaryButtonAction = {}
                                        appViewModel.messageBoxCloseButtonAction = {}
                                        
                                        withAnimation(.spring()) {
                                            appViewModel.showMessageBoxBackground = false
                                            appViewModel.showMessageBox = false
                                        }
                                    }
                                    
                                    withAnimation(.spring()) {
                                        appViewModel.showMessageBoxBackground = true
                                        appViewModel.showMessageBox = true
                                    }
                                }
                            } else {
                                withAnimation(.spring()) {
                                    vibrateOffset += 1
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("주문하기")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical)
                            
                            Spacer()
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("main-highlight-color"))
                    }
                    .matchedGeometryEffect(id: "구매하기", in: heroEffect)
                } else {
                    Button {
                        withAnimation(.spring()) {
                            showOptionSheet = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("주문하기")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.vertical)
                            
                            Spacer()
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("main-highlight-color"))
                    }
                    .matchedGeometryEffect(id: "구매하기", in: heroEffect)
                }
            }
                .padding(.vertical, 8)
                .padding(.horizontal, 25)
                .frame(height: 70)
                .background(.white)
        }
        .background(.clear)
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
