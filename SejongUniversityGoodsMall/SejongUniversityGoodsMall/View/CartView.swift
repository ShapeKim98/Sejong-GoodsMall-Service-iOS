//
//  CartView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/13.
//

import SwiftUI

struct CartView: View {
    @Environment(\.dismiss) var dismiss
    
    @Namespace var orderTypeSeletection
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State private var isAllSelected: Bool = false
    @State private var message: String = ""
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                orderTypeSelection()
                    .unredacted()
                
                allSeletionAndDeleteSeleted()
                
                Rectangle()
                    .fill(Color("shape-bkg-color"))
                    .frame(height: 10)
                
                if (goodsViewModel.pickUpCart.isEmpty && goodsViewModel.isCartGoodsListLoading) || (goodsViewModel.deliveryCart.isEmpty && goodsViewModel.isCartGoodsListLoading) {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .controlSize(.large)
                        .padding()
                        .tint(Color("main-highlight-color"))
                        .unredacted()
                } else {
                    Group {
                        switch goodsViewModel.orderType {
                            case .pickUpOrder where goodsViewModel.pickUpCart.isEmpty:
                                emptyCart()
                            case .deliveryOrder where goodsViewModel.deliveryCart.isEmpty:
                                emptyCart()
                            default:
                                cartGoodsList()
                        }
                    }
                    .overlay(alignment: .bottom) {
                        if goodsViewModel.completeSendCartGoods {
                            alertMessageView(message: message)
                                .padding()
                                .onAppear() {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        withAnimation(.easeInOut) {
                                            goodsViewModel.completeSendCartGoods = false
                                        }
                                    }
                                }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    goodsViewModel.showOrderView = true
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("\(goodsViewModel.selectedCartGoodsPrice)원 주문하기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(goodsViewModel.selectedCartGoodsPrice != 0 && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
                    }
                }
                .disabled(goodsViewModel.selectedCartGoodsPrice == 0 || loginViewModel.isLoading)
                .padding([.horizontal, .bottom])
                .padding(.bottom, 20)
            }
        }
        .background(.white)
        .onAppear() {
            withAnimation(.easeInOut) {
                goodsViewModel.isCartGoodsListLoading = true
            }
            
            goodsViewModel.orderType = .pickUpOrder
            
            if !loginViewModel.isAuthenticate {
                appViewModel.createMessageBox(title: "로그인이 필요한 서비스 입니다", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러 가기", secondaryButtonTitle: "계속 둘러보기") {
                    withAnimation(.spring()) {
                        appViewModel.showMessageBoxBackground = false
                        appViewModel.showMessageBox = false
                    }
                    
                    loginViewModel.showLoginView = true
                    
                    dismiss()
                } secondaryButtonAction: {
                    withAnimation(.spring()) {
                        appViewModel.showMessageBoxBackground = false
                        appViewModel.showMessageBox = false
                    }
                    
                    dismiss()
                } closeButtonAction: {
                    appViewModel.deleteMessageBox()
                    
                    dismiss()
                }
                
                withAnimation(.spring()) {
                    appViewModel.showMessageBoxBackground = true
                    appViewModel.showMessageBox = true
                }
            } else {
                goodsViewModel.fetchCartGoods(token: loginViewModel.returnToken())
            }
        }
        .onDisappear() {
            goodsViewModel.cartGoodsSelections.removeAll()
            goodsViewModel.pickUpCart.forEach { goods in
                goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
            }
        }
        .fullScreenCover(isPresented: $goodsViewModel.showOrderView) {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    OrderView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    goodsViewModel.orderGoods.removeAll()
                                    goodsViewModel.orderGoodsListFromCart.removeAll()
                                    goodsViewModel.cartIDList.removeAll()
                                    goodsViewModel.isOrderComplete = false
                                    
                                    goodsViewModel.fetchCartGoods(token: loginViewModel.returnToken())
                                    
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
                            switch goodsViewModel.orderType {
                                case .pickUpOrder:
                                    goodsViewModel.pickUpCart.forEach { goods in
                                        if let isSelected = goodsViewModel.cartGoodsSelections[goods.id], isSelected {
                                            goodsViewModel.orderGoods.append(OrderItem(itemID: nil, color: goods.color, size: goods.size, quantity: goods.quantity, price: goods.price, orderStatus: nil))
                                            goodsViewModel.cartIDList.append(goods.id)
                                            goodsViewModel.orderGoodsListFromCart.append(goods)
                                            goodsViewModel.fetchorderGoodsDeliveryFeeFromCart(id: goods.goodsID)
                                        }
                                    }
                                    
                                    break
                                case .deliveryOrder:
                                    goodsViewModel.deliveryCart.forEach { goods in
                                        if let isSelected = goodsViewModel.cartGoodsSelections[goods.id], isSelected {
                                            goodsViewModel.orderGoods.append(OrderItem(itemID: nil, color: goods.color, size: goods.size, quantity: goods.quantity, price: goods.price, orderStatus: nil))
                                            goodsViewModel.cartIDList.append(goods.id)
                                            goodsViewModel.orderGoodsListFromCart.append(goods)
                                            goodsViewModel.fetchorderGoodsDeliveryFeeFromCart(id: goods.goodsID)
                                        }
                                    }
                            }
                        }
                        .onDisappear() {
                            goodsViewModel.cartGoodsSelections.removeAll()
                            goodsViewModel.updateCartData()
                        }
                }
                .overlay {
                    ZStack {
                        if appViewModel.showMessageBoxBackground {
                            Color(.black).opacity(0.4)
                        }
                        
                        if appViewModel.showMessageBox {
                            MessageBoxView()
                                .transition(.move(edge: .bottom))
                        }
                    }
                    .ignoresSafeArea()
                }
            } else {
                NavigationView {
                    OrderView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    goodsViewModel.orderGoods.removeAll()
                                    goodsViewModel.orderGoodsListFromCart.removeAll()
                                    goodsViewModel.cartIDList.removeAll()
                                    goodsViewModel.isOrderComplete = false
                                    
                                    goodsViewModel.fetchCartGoods(token: loginViewModel.returnToken())
                                    
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
                            switch goodsViewModel.orderType {
                                case .pickUpOrder:
                                    goodsViewModel.pickUpCart.forEach { goods in
                                        if let isSelected = goodsViewModel.cartGoodsSelections[goods.id], isSelected {
                                            goodsViewModel.orderGoods.append(OrderItem(itemID: nil, color: goods.color, size: goods.size, quantity: goods.quantity, price: goods.price, orderStatus: nil))
                                            goodsViewModel.cartIDList.append(goods.id)
                                            goodsViewModel.orderGoodsListFromCart.append(goods)
                                            goodsViewModel.fetchorderGoodsDeliveryFeeFromCart(id: goods.memberID)
                                        }
                                    }
                                    
                                    break
                                case .deliveryOrder:
                                    goodsViewModel.deliveryCart.forEach { goods in
                                        if let isSelected = goodsViewModel.cartGoodsSelections[goods.id], isSelected {
                                            goodsViewModel.orderGoods.append(OrderItem(itemID: nil, color: goods.color, size: goods.size, quantity: goods.quantity, price: goods.price, orderStatus: nil))
                                            goodsViewModel.cartIDList.append(goods.id)
                                            goodsViewModel.orderGoodsListFromCart.append(goods)
                                            goodsViewModel.fetchorderGoodsDeliveryFeeFromCart(id: goods.memberID)
                                        }
                                    }
                            }
                        }
                        .onDisappear() {
                            goodsViewModel.cartGoodsSelections.removeAll()
                            goodsViewModel.updateCartData()
                            goodsViewModel.orderGoodsDeliveryFeeFromCart.removeAll()
                        }
                }
                .overlay {
                    ZStack {
                        if appViewModel.showMessageBoxBackground {
                            Color(.black).opacity(0.4)
                        }
                        
                        if appViewModel.showMessageBox {
                            MessageBoxView()
                                .transition(.move(edge: .bottom))
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        }
    }
    
    @ViewBuilder
    func orderTypeSelection() -> some View {
        HStack {
            Spacer()
            
            orderTypeButton("현장수령", .pickUpOrder) {
                isAllSelected = false
                
                goodsViewModel.cartGoodsSelections.removeAll()
                goodsViewModel.pickUpCart.forEach { goods in
                    goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                }
                
                withAnimation(.spring()) {
                    goodsViewModel.orderType = .pickUpOrder
                }
                
                goodsViewModel.updateCartData()
            }
            
            Spacer(minLength: 150)
            
            orderTypeButton("택배수령", .deliveryOrder) {
                isAllSelected = false
                
                goodsViewModel.cartGoodsSelections.removeAll()
                goodsViewModel.deliveryCart.forEach { goods in
                    goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                }
                
                withAnimation(.spring()) {
                    goodsViewModel.orderType = .deliveryOrder
                }
                
                goodsViewModel.updateCartData()
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
    func orderTypeButton(_ title: String, _ seleted: OrderType, _ action: @escaping () -> Void) -> some View {
        let isSelected = goodsViewModel.orderType == seleted
        
        Button(action: action) {
            VStack {
                switch seleted {
                    case .pickUpOrder:
                        HStack(spacing: 0) {
                            Text(title)
                                .font(.subheadline)
                                .fontWeight(isSelected ? .bold : .light)
                                .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                                .padding(.bottom, 10)
                                .unredacted()
                            
                            Text(" \(goodsViewModel.pickUpCart.count)")
                                .font(.subheadline)
                                .fontWeight(isSelected ? .bold : .light)
                                .foregroundColor(isSelected ? Color("point-color") : Color("secondary-text-color"))
                                .padding(.bottom, 10)
                                .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                        }
                    case .deliveryOrder:
                        HStack(spacing: 0) {
                            Text(title)
                                .font(.subheadline)
                                .fontWeight(isSelected ? .bold : .light)
                                .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                                .padding(.bottom, 10)
                                .unredacted()
                            
                            Text(" \(goodsViewModel.deliveryCart.count)")
                                .font(.subheadline)
                                .fontWeight(isSelected ? .bold : .light)
                                .foregroundColor(isSelected ? Color("point-color") : Color("secondary-text-color"))
                                .padding(.bottom, 10)
                                .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                        }
                }
            }
            .overlay(alignment: .bottom) {
                if isSelected {
                    Rectangle()
                        .foregroundColor(Color("main-highlight-color"))
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "선택", in: orderTypeSeletection)
                }
            }
        }
    }
    
    @ViewBuilder
    func allSeletionAndDeleteSeleted() -> some View {
        HStack {
            Button {
                switch goodsViewModel.orderType {
                    case .pickUpOrder where !goodsViewModel.pickUpCart.isEmpty:
                        withAnimation(.easeInOut) {
                            isAllSelected.toggle()
                            
                            if isAllSelected {
                                switch goodsViewModel.orderType {
                                    case .pickUpOrder:
                                        goodsViewModel.pickUpCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(true, forKey: goods.id)
                                        }
                                        break
                                    case .deliveryOrder:
                                        goodsViewModel.deliveryCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(true, forKey: goods.id)
                                        }
                                        break
                                }
                            } else {
                                switch goodsViewModel.orderType {
                                    case .pickUpOrder:
                                        goodsViewModel.pickUpCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                                        }
                                        break
                                    case .deliveryOrder:
                                        goodsViewModel.deliveryCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                                        }
                                        break
                                }
                            }
                            
                            goodsViewModel.updateCartData()
                        }
                        break
                    case .deliveryOrder where !goodsViewModel.deliveryCart.isEmpty:
                        withAnimation(.easeInOut) {
                            isAllSelected.toggle()
                            
                            if isAllSelected {
                                switch goodsViewModel.orderType {
                                    case .pickUpOrder:
                                        goodsViewModel.pickUpCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(true, forKey: goods.id)
                                        }
                                        break
                                    case .deliveryOrder:
                                        goodsViewModel.deliveryCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(true, forKey: goods.id)
                                        }
                                        break
                                }
                            } else {
                                switch goodsViewModel.orderType {
                                    case .pickUpOrder:
                                        goodsViewModel.pickUpCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                                        }
                                        break
                                    case .deliveryOrder:
                                        goodsViewModel.deliveryCart.forEach { goods in
                                            goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                                        }
                                        break
                                }
                            }
                            
                            goodsViewModel.updateCartData()
                        }
                        break
                    default:
                        break
                }
                
            } label: {
                HStack {
                    Label("선택", systemImage: "checkmark.circle.fill")
                        .font(.title2)
                        .labelStyle(.iconOnly)
                        .foregroundColor(goodsViewModel.selectedCartGoodsCount > 0 ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
                    
                    HStack(spacing: 0) {
                        Text("전체 ")
                            .foregroundColor(Color("secondary-text-color"))
                            .unredacted()
                        
                        Text("\(goodsViewModel.selectedCartGoodsCount)")
                            .foregroundColor(Color("main-text-color"))
                        
                        Text("개")
                            .foregroundColor(Color("secondary-text-color"))
                            .unredacted()
                    }
                }
            }
            
            Spacer()
            
            Button {
                if goodsViewModel.cartGoodsSelections.contains(where: { key, value in
                    value == true
                }) {
                    appViewModel.createMessageBox(title: "선택하신 상품을 삭제하시겠습니까?", secondaryTitle: "다음에 구매하실 예정이라면 찜하기에 잠시 보관해두세요.", mainButtonTitle: "찜하기에 보관하기", secondaryButtonTitle: "삭제하기") {
                        withAnimation(.spring()) {
                            appViewModel.showMessageBoxBackground = false
                            appViewModel.showMessageBox = false
                            
                            switch goodsViewModel.orderType {
                                case .pickUpOrder:
                                    goodsViewModel.pickUpCart.forEach { goods in
                                        if let isSelected = goodsViewModel.cartGoodsSelections[goods.id], isSelected {
                                            goodsViewModel.sendIsScrapFromCart(id: goods.goodsID, token: loginViewModel.returnToken())
                                        }
                                    }
                                    break
                                case .deliveryOrder:
                                    goodsViewModel.deliveryCart.forEach { goods in
                                        if let isSelected = goodsViewModel.cartGoodsSelections[goods.id], isSelected {
                                            goodsViewModel.sendIsScrapFromCart(id: goods.goodsID, token: loginViewModel.returnToken())
                                        }
                                    }
                                    break
                            }
                            
                            goodsViewModel.deleteCartGoods(token: loginViewModel.returnToken())
                            
                            message = "찜하기에 보관되었습니다."
                        }
                    } secondaryButtonAction: {
                        withAnimation(.spring()) {
                            goodsViewModel.deleteCartGoods(token: loginViewModel.returnToken())
                            appViewModel.showMessageBoxBackground = false
                            appViewModel.showMessageBox = false
                            
                            message = "선택한 상품을 삭제했습니다."
                        }
                    } closeButtonAction: {
                        appViewModel.deleteMessageBox()
                    }
                    
                    withAnimation(.spring()) {
                        appViewModel.showMessageBoxBackground = true
                        appViewModel.showMessageBox = true
                    }
                }
            } label: {
                Text("선택 삭제")
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
            }
            .unredacted()
        }
        .padding()
    }
    
    @ViewBuilder
    func emptyCart() -> some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Image(systemName: "cart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                    .foregroundColor(Color("shape-bkg-color"))
                    .padding()
                
                Spacer()
            }
            
            HStack {
                Spacer()
                
                VStack {
                    Text("장바구니에 상품이 없습니다.")
                        .foregroundColor(Color("secondary-text-color"))
                    
                    Text("상품을 추가해 보세요.")
                        .foregroundColor(Color("secondary-text-color"))
                }
                .padding()
                
                Spacer()
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func cartGoodsList() -> some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                
                
                switch goodsViewModel.orderType {
                    case .pickUpOrder:
                        ForEach(goodsViewModel.pickUpCart, id: \.id) { goods in
                            subCartGoods(goods: goods)
                                .onAppear() {
                                    if goodsViewModel.cartGoodsSelections[goods.id] == nil {
                                        goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                                    }
                                }
                        }
                    case .deliveryOrder:
                        ForEach(goodsViewModel.deliveryCart, id: \.id) { goods in
                            subCartGoods(goods: goods)
                                .onAppear() {
                                    if goodsViewModel.cartGoodsSelections[goods.id] == nil {
                                        goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                                    }
                                }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func subCartGoods(goods: CartGoodsResponse) -> some View {
        VStack {
            HStack(alignment: .top) {
                Button {
                    withAnimation(.easeInOut) {
                        let _ = goodsViewModel.cartGoodsSelections.updateValue((goodsViewModel.cartGoodsSelections[goods.id] ?? false) ? false : true, forKey: goods.id)
                        
                        goodsViewModel.updateCartData()
                    }
                } label: {
                    Label("선택", systemImage: "checkmark.circle.fill")
                        .font(.title2)
                        .labelStyle(.iconOnly)
                        .foregroundColor(goodsViewModel.cartGoodsSelections[goods.id] ?? false ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
                }
                
                NavigationLink {
                    GoodsDetailView()
                        .onAppear(){
                            withAnimation(.easeInOut) {
                                goodsViewModel.isGoodsDetailLoading = true
                            }
                            goodsViewModel.fetchGoodsDetail(id: goods.goodsID)
                        }
                        .navigationTitle("상품 정보")
                        .navigationBarTitleDisplayMode(.inline)
                        .modifier(NavigationColorModifier())
                        .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                } label: {
                    if goodsViewModel.isCartGoodsListLoading {
                        Color("main-shape-bkg-color")
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1)
                    } else {
                        AsyncImage(url: URL(string: goods.repImage.oriImgName)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            ZStack {
                                Color("main-shape-bkg-color")
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                                ProgressView()
                                    .tint(Color("main-highlight-color"))
                            }
                        }
                        .frame(width: 100, height: 100)
                        .shadow(radius: 1)
                    }
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(goods.title)
                            .foregroundColor(Color("main-text-color"))
                            .padding(.trailing)
                        
                        Spacer()
                        
                        Button {
                            withAnimation(.spring()) {
                                goodsViewModel.deleteIndividualCartGoods(id: goods.id, token: loginViewModel.returnToken())
                            }
                        } label: {
                            Label("삭제", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                                .frame(minWidth: 21, minHeight: 21)
                                .foregroundColor(Color("main-text-color"))
                        }
                        .unredacted()
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        if goods.color != nil || goods.size != nil {
                            Group {
                                if let color = goods.color, let size = goods.size {
                                    Text("\(color), \(size)")
                                } else {
                                    Text("\(goods.color ?? "")\(goods.size ?? "")")
                                }
                            }
                            .font(.caption.bold())
                            .foregroundColor(Color("main-text-color"))
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text(goods.seller)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("point-color"))
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation(.easeInOut) {
                                goodsViewModel.updateCartGoods(id: goods.id, quantity: goods.quantity - 1, token: loginViewModel.returnToken())
                            }
                        } label: {
                            Label("마이너스", systemImage: "minus")
                                .labelStyle(.iconOnly)
                                .font(.caption2)
                                .foregroundColor(Color("main-text-color"))
                                .frame(minWidth: 24, minHeight: 24)
                                .background(Circle().fill(Color("shape-bkg-color")))
                        }
                        .disabled(goods.quantity <= 1)
                        .opacity(goods.quantity <= 1 ? 0.5 : 1)
                        .unredacted()
                        
                        Text("\(goods.quantity)")
                            .font(.footnote)
                            .fontWeight(.light)
                        
                        Button {
                            withAnimation(.easeInOut) {
                                goodsViewModel.updateCartGoods(id: goods.id, quantity: goods.quantity + 1, token: loginViewModel.returnToken())
                            }
                        } label: {
                            Label("플러스", systemImage: "plus")
                                .labelStyle(.iconOnly)
                                .font(.caption2)
                                .foregroundColor(Color("main-text-color"))
                                .frame(minWidth: 24, minHeight: 24)
                                .background(Circle().fill(Color("shape-bkg-color")))
                        }
                        .unredacted()
                        
                        Spacer()
                        
                        Text("\(goods.price)원")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                    }
                }
                .padding(.top, 5)
                .padding(.horizontal, 5)
                .redacted(reason: goodsViewModel.isCartGoodsListLoading ? .placeholder : [])
            }
            .padding(.vertical)
            
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func alertMessageView(message: String) -> some View {
        HStack {
            Spacer()
            
            Text(message)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(2)
                .background {
                    Rectangle()
                        .foregroundColor(Color("main-text-color"))
                }
            
            Spacer()
        }
        .frame(height: 70)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(AppViewModel())
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
    }
}
