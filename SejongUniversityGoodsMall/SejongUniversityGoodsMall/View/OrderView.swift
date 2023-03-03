//
//  PickUpOrderView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/19.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @FocusState private var currentField: FocusedTextField?
    
    @State private var buyerName: String = ""
    @State private var isValidBuyerName: Bool = false
    @State private var phoneNumber: String = ""
    @State private var isValidPhoneNumber: Bool = false
    @State private var orderPrice: Int = 0
    @State private var postalNumber: String = ""
    @State private var isValidPostalNumber: Bool = false
    @State private var mainAddress: String = ""
    @State private var isValidMainAddress: Bool = false
    @State private var detailAddress: String = ""
    @State private var deliveryRequirements: String = ""
    @State private var showFindAddressView: Bool = false
    @State private var showDeliveryInfo: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            if goodsViewModel.isOrderComplete {
                OrderCompleteView()
            } else {
                Rectangle()
                    .fill(Color("shape-bkg-color"))
                    .frame(height: 10)
                
                ScrollView {
                    switch goodsViewModel.orderType {
                        case .pickUpOrder:
                            pickUpInformation()
                        case .deliveryOrder:
                            deliveryInformation()
                    }
                    
                    orderGoodsList()
                    
                    deliveryInfoAlert()
                    
                    orderButton()
                        .padding(.top, 30)
                        .onAppear() {
                            orderPrice = 0
                            if goodsViewModel.cartIDList.isEmpty {
                                goodsViewModel.orderGoods.forEach { goods in
                                    orderPrice += (goods.price)
                                }
                            } else {
                                goodsViewModel.orderGoods.forEach { goods in
                                    orderPrice += (goods.price * goods.quantity)
                                }
                            }
                        }
                }
            }
        }
        .navigationTitle(goodsViewModel.isOrderComplete ? "주문 완료" : "주문서 작성")
        .navigationBarTitleDisplayMode(.inline)
        .modifier(NavigationColorModifier())
        .background(.white)
    }
    
    @ViewBuilder
    func pickUpInformation() -> some View {
        VStack {
            HStack {
                Text("수령 정보")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            TextField("수령인", text: $buyerName, prompt: Text("수령인"))
                .modifier(TextFieldModifier(text: $buyerName, isValidInput: $isValidBuyerName, currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .name, focusedTextField: .nameField, submitLabel: .next))
                .onChange(of: buyerName) { newValue in
                    withAnimation(.easeInOut) {
                        isValidBuyerName = newValue != "" ? true : false
                    }
                }
                .overlay {
                    if isValidBuyerName {
                        HStack {
                            Spacer()
                            
                            DrawingCheckmarkView()
                        }
                        .padding()
                    }
                }
            
            HStack {
                Text(!isValidBuyerName && buyerName != "" ? "필수 항목입니다." : " ")
                    .font(.caption2)
                    .foregroundColor(Color("main-highlight-color"))
                
                Spacer()
            }
            .padding(.horizontal)
            
            TextField("휴대전화", text: $phoneNumber, prompt: Text("휴대전화('-'포함해서 입력)"))
                .modifier(TextFieldModifier(text: $phoneNumber, isValidInput: $isValidPhoneNumber, currentField: _currentField, font: .subheadline.bold(), keyboardType: .numbersAndPunctuation, contentType: .telephoneNumber, focusedTextField: .phoneNumberField, submitLabel: .done))
                .onChange(of: phoneNumber) { newValue in
                    if(newValue.range(of:"^01([0|1|6|7|8|9]?)-([0-9]{3,4})-([0-9]{4})$", options: .regularExpression) != nil) {
                        withAnimation(.easeInOut){
                            isValidPhoneNumber = true
                        }
                    } else {
                        withAnimation(.easeInOut) {
                            isValidPhoneNumber = false
                        }
                    }
                }
                .overlay {
                    if isValidPhoneNumber {
                        HStack {
                            Spacer()
                            
                            DrawingCheckmarkView()
                        }
                        .padding()
                    }
                }
            
            HStack {
                Text(!isValidPhoneNumber && phoneNumber != "" ? "올바르지 않은 휴대전화번호 입니다" : " ")
                    .font(.caption2)
                    .foregroundColor(Color("main-highlight-color"))
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    @ViewBuilder
    func deliveryInformation() -> some View {
        VStack {
            HStack {
                Text("배송 정보")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            Group {
                TextField("수령인", text: $buyerName, prompt: Text("수령인"))
                    .modifier(TextFieldModifier(text: $buyerName, isValidInput: $isValidBuyerName, currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .name, focusedTextField: .nameField, submitLabel: .next))
                    .onChange(of: buyerName) { newValue in
                        withAnimation(.easeInOut) {
                            isValidBuyerName = newValue != "" ? true : false
                        }
                    }
                    .overlay {
                        if isValidBuyerName {
                            HStack {
                                Spacer()
                                
                                DrawingCheckmarkView()
                            }
                            .padding()
                        }
                    }
                
                HStack {
                    Text(!isValidBuyerName && buyerName != "" ? "필수 항목입니다." : " ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Group {
                TextField("휴대전화", text: $phoneNumber, prompt: Text("휴대전화('-'포함해서 입력)"))
                    .modifier(TextFieldModifier(text: $phoneNumber, isValidInput: $isValidPhoneNumber, currentField: _currentField, font: .subheadline.bold(), keyboardType: .numbersAndPunctuation, contentType: .telephoneNumber, focusedTextField: .phoneNumberField, submitLabel: .done))
                    .onChange(of: phoneNumber) { newValue in
                        if(newValue.range(of:"^01([0|1|6|7|8|9]?)-([0-9]{3,4})-([0-9]{4})$", options: .regularExpression) != nil) {
                            withAnimation(.easeInOut) {
                                isValidPhoneNumber = true
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                isValidPhoneNumber = false
                            }
                        }
                    }
                    .overlay {
                        if isValidPhoneNumber {
                            HStack {
                                Spacer()
                                
                                DrawingCheckmarkView()
                            }
                            .padding()
                        }
                    }
                
                HStack {
                    Text(!isValidPhoneNumber && phoneNumber != "" ? "올바르지 않은 휴대전화번호 입니다" : " ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Group {
                TextField("우편번호", text: $postalNumber, prompt: Text("우편번호"))
                    .modifier(TextFieldModifier(text: $postalNumber, isValidInput: $isValidPostalNumber, currentField: _currentField, font: .subheadline.bold(), keyboardType: .numberPad, contentType: .postalCode, focusedTextField: .postalNumberField, submitLabel: .next))
                    .onChange(of: postalNumber) { newValue in
                        if newValue.count == 5 {
                            withAnimation(.easeInOut) {
                                isValidPostalNumber = true
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                isValidPostalNumber = false
                            }
                        }
                    }
                    .overlay {
                        HStack {
                            Spacer()
                            
                            if isValidPostalNumber {
                                DrawingCheckmarkView()
                            }
                            
                            Button {
                                showFindAddressView = true
                            } label: {
                                Text("주소찾기")
                                    .font(.caption2)
                                    .foregroundColor(Color("main-text-color"))
                                    .background(alignment: .bottom) {
                                        Rectangle()
                                            .fill(Color("main-text-color"))
                                            .frame(height: 0.5)
                                    }
                            }
                        }
                        .padding()
                        .fullScreenCover(isPresented: $showFindAddressView) {
                            if #available(iOS 16.0, *) {
                                NavigationStack {
                                    findAddressView()
                                        .navigationTitle("우편번호 찾기")
                                        .navigationBarTitleDisplayMode(.inline)
                                        .modifier(NavigationColorModifier())
                                }
                            } else {
                                NavigationView {
                                    findAddressView()
                                        .navigationTitle("우편번호 찾기")
                                        .navigationBarTitleDisplayMode(.inline)
                                        .modifier(NavigationColorModifier())
                                }
                            }
                        }
                    }
                
                HStack {
                    Text(!isValidPostalNumber && postalNumber != "" ? "필수 항목입니다." : " ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Group {
                TextField("주소", text: $mainAddress, prompt: Text("주소"))
                    .modifier(TextFieldModifier(text: $mainAddress, isValidInput: $isValidMainAddress, currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .streetAddressLine1, focusedTextField: .address1, submitLabel: .next))
                    .onChange(of: mainAddress) { newValue in
                        if newValue != "" {
                            withAnimation(.easeInOut) {
                                isValidMainAddress = true
                            }
                        } else {
                            withAnimation(.easeInOut) {
                                isValidMainAddress = false
                            }
                        }
                    }
                    .overlay {
                        if isValidMainAddress {
                            HStack {
                                Spacer()
                                
                                DrawingCheckmarkView()
                            }
                            .padding()
                        }
                    }
                
                HStack {
                    Text(!isValidMainAddress && mainAddress != "" ? "필수 항목입니다." : " ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Group {
                TextField("상세주소", text: $detailAddress, prompt: Text("상세주소"))
                    .modifier(TextFieldModifier(text: $detailAddress, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .streetAddressLine2, focusedTextField: .address2, submitLabel: .next))
                
                HStack {
                    Text(" ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Group {
                TextField("배송 요청사항", text: $deliveryRequirements, prompt: Text("배송 요청사항(선택)"))
                    .modifier(TextFieldModifier(text: $deliveryRequirements, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .name, focusedTextField: .deliveryRequirements, submitLabel: .done))
                
                HStack {
                    Text(" ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func findAddressView() -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 10)
            
            Text("화면 준비중")
                .padding()
            
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showFindAddressView = false
                } label: {
                    Label("닫기", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .font(.footnote)
                        .foregroundColor(Color("main-text-color"))
                }
            }
        }
    }
    
    @ViewBuilder
    func orderGoodsList() -> some View {
        VStack {
            HStack {
                Text("상품 정보")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns) {
                if !goodsViewModel.cartIDList.isEmpty {
                    ForEach(goodsViewModel.orderGoodsListFromCart) { goods in
                        subOrderGoodsFromCart(goods: goods)
                    }
                } else {
                    ForEach(goodsViewModel.orderGoods, id: \.hashValue) { goods in
                        subOrderGoods(goods: goods)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func subOrderGoods(goods: OrderItem) -> some View {
        VStack {
            HStack() {
                if let image = goodsViewModel.goodsDetail.goodsImages.first {
                    AsyncImage(url: URL(string: image.oriImgName)) { image in
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
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        
                        Text(goodsViewModel.goodsDetail.title)
                            .foregroundColor(Color("main-text-color"))
                            .padding(.trailing)
                        
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
                            .padding(.leading)
                            .background(alignment: .leading) {
                                Rectangle()
                                    .fill(Color("main-text-color"))
                                    .frame(width: 1)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Text(goodsViewModel.goodsDetail.seller.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("point-color"))
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Text("수량 \(goods.quantity)개")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("secondary-text-color"))
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        if goodsViewModel.cartIDList.isEmpty {
                            Text("\(goods.price)원")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color("main-text-color"))
                        } else {
                            Text("\(goods.price * goods.quantity)원")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color("main-text-color"))
                        }
                        
                        Spacer()
                    }
                }
                .padding(10)
            }
            .padding(.vertical)
            
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func subOrderGoodsFromCart(goods: CartGoodsResponse) -> some View {
        VStack {
            HStack() {
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
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        
                        Text(goods.title)
                            .foregroundColor(Color("main-text-color"))
                            .padding(.trailing)
                        
                        Group {
                            if let color = goods.color, let size = goods.size {
                                Text("\(color), \(size)")
                            } else {
                                Text("\(goods.color ?? "")\(goods.size ?? "")")
                            }
                        }
                        .font(.caption.bold())
                        .foregroundColor(Color("main-text-color"))
                        .padding(.leading)
                        .background(alignment: .leading) {
                            Rectangle()
                                .fill(Color("main-text-color"))
                                .frame(width: 1)
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
                        Text("\(goods.price)원")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                        
                        Spacer()
                        
                        Text("수량 \(goods.quantity)개")
                            .font(.caption.bold())
                            .foregroundColor(Color("main-text-color"))
                    }
                }
                .padding(10)
            }
            .padding(.vertical)
            
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func orderButton() -> some View {
        if goodsViewModel.orderType == .pickUpOrder {
            Button {
                goodsViewModel.isSendOrderGoodsLoading = true
                
                if goodsViewModel.cartIDList.isEmpty {
                    goodsViewModel.sendOrderGoodsFromDetailGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: nil, deliveryRequest: nil, token: loginViewModel.returnToken())
                } else {
                    goodsViewModel.sendOrderGoodsFromCart(buyerName: buyerName, phoneNumber: phoneNumber, address: nil, deliveryRequest: nil, token: loginViewModel.returnToken())
                }
            } label: {
                HStack {
                    Spacer()
                    
                    if goodsViewModel.isSendOrderGoodsLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("\(orderPrice)원 주문하기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(isValidBuyerName && isValidPhoneNumber ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
                }
            }
            .disabled(!isValidBuyerName || !isValidPhoneNumber)
            .padding([.horizontal, .bottom])
            .padding(.bottom, 20)
        } else {
            Button {
                goodsViewModel.isSendOrderGoodsLoading = true
                
                if goodsViewModel.cartIDList.isEmpty {
                    goodsViewModel.sendOrderGoodsFromDetailGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: Address(mainAddress: mainAddress, detailAddress: detailAddress, zipcode: postalNumber), deliveryRequest: deliveryRequirements == "" ? nil : deliveryRequirements, token: loginViewModel.returnToken())
                } else {
                    goodsViewModel.sendOrderGoodsFromCart(buyerName: buyerName, phoneNumber: phoneNumber, address: Address(mainAddress: mainAddress, detailAddress: detailAddress, zipcode: postalNumber), deliveryRequest: deliveryRequirements == "" ? nil : deliveryRequirements, token: loginViewModel.returnToken())
                }
            } label: {
                HStack {
                    Spacer()
                    
                    if goodsViewModel.isSendOrderGoodsLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("\(orderPrice)원 주문하기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(isValidBuyerName && isValidPhoneNumber && isValidPostalNumber && isValidMainAddress ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
                }
            }
            .disabled(!isValidBuyerName || !isValidPhoneNumber || !isValidPostalNumber || !isValidMainAddress)
            .padding([.horizontal, .bottom])
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    func deliveryInfoAlert() -> some View {
        HStack {
            Text("• 기본 배송료는 3,000원 입니다.\n• 40,000원 이상 구매시 무료배송입니다.")
                .font(.caption)
                .foregroundColor(Color("secondary-text-color"))
            
            Spacer()
            
            Button {
                showDeliveryInfo = true
            } label: {
                Label("도움말", systemImage: "info.circle")
                    .font(.title3)
                    .labelStyle(.iconOnly)
                    .foregroundColor(Color("point-color"))
            }
            .alert("지역별 추가 배송비 안내", isPresented: $showDeliveryInfo) {
                Button {
                    showDeliveryInfo = false
                } label: {
                    Text("확인")
                }
                .foregroundColor(Color("main-highlight-color"))
            } message: {
                VStack {
                    Text("제주도 3,000원 추가\n제주도 외 도서산간 5,000원 추가").font(.caption)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
        .environmentObject(LoginViewModel())
        .environmentObject(GoodsViewModel())
    }
}
