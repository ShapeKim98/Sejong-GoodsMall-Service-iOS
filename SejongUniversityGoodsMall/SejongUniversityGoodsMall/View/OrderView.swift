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
    
    @Binding var isPresented: Bool
    
    @FocusState private var currentField: FocusedTextField?
    
    @State var orderGoods: [OrderItem]
    @State private var buyerName: String = ""
    @State private var isValidBuyerName: Bool = false
    @State private var phoneNumber: String = ""
    @State private var isValidPhoneNumber: Bool = false
    @State private var orderPrice: Int = 0
    @State private var postalNumber: String = ""
    @State private var isValidPostalNumber: Bool = false
    @State private var address1: String = ""
    @State private var isValidAddress1: Bool = false
    @State private var address2: String = ""
    @State private var deliveryRequirements: String = ""
    @State private var showFindAddressView: Bool = false
    @State private var showOrderCompleteView: Bool = false
    @State private var limitDate: String = ""
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
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
                
                    LazyVGrid(columns: columns) {
                    orderGoodsList()
                }
                
                orderButton()
                    .padding(.top, 30)
            }
        }
        .background(.white)
        .onAppear() {
            orderPrice = 0
            orderGoods.forEach { goods in
                orderPrice += (goods.price * goods.quantity)
            }
        }
        .fullScreenCover(isPresented: $showOrderCompleteView) {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    orderCompleteView()
                        .navigationTitle("주문완료")
                        .navigationBarTitleDisplayMode(.inline)
                        .modifier(NavigationColorModifier())
                        .background(.white)
                }
            } else {
                NavigationView {
                    orderCompleteView()
                        .navigationTitle("주문완료")
                        .navigationBarTitleDisplayMode(.inline)
                        .modifier(NavigationColorModifier())
                        .background(.white)
                }
            }
        }
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
                    withAnimation {
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
                        withAnimation {
                            isValidPhoneNumber = true
                        }
                    } else {
                        withAnimation {
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
                        withAnimation {
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
                    .modifier(TextFieldModifier(text: $phoneNumber, isValidInput: $isValidPhoneNumber, currentField: _currentField, font: .subheadline.bold(), keyboardType: .phonePad, contentType: .telephoneNumber, focusedTextField: .phoneNumberField, submitLabel: .done))
                    .onChange(of: phoneNumber) { newValue in
                        if(newValue.range(of:"^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$", options: .regularExpression) != nil) {
                            withAnimation {
                                isValidPhoneNumber = true
                            }
                        } else {
                            withAnimation {
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
                            withAnimation {
                                isValidPostalNumber = true
                            }
                        } else {
                            withAnimation {
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
                TextField("주소", text: $address1, prompt: Text("주소"))
                    .modifier(TextFieldModifier(text: $address1, isValidInput: $isValidAddress1, currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .streetAddressLine1, focusedTextField: .address1, submitLabel: .next))
                    .onChange(of: address1) { newValue in
                        if newValue != "" {
                            withAnimation {
                                isValidAddress1 = true
                            }
                        } else {
                            withAnimation {
                                isValidAddress1 = false
                            }
                        }
                    }
                    .overlay {
                        if isValidAddress1 {
                            HStack {
                                Spacer()
                                
                                DrawingCheckmarkView()
                            }
                            .padding()
                        }
                    }
                
                HStack {
                    Text(!isValidAddress1 && address1 != "" ? "필수 항목입니다." : " ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Group {
                TextField("상세주소", text: $address2, prompt: Text("상세주소"))
                    .modifier(TextFieldModifier(text: $address2, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .streetAddressLine2, focusedTextField: .address2, submitLabel: .next))
                
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
                ForEach(orderGoods, id: \.hashValue) { goods in
                    subOrderGoods(goods: goods)
                }
            }
        }
    }
    
    @ViewBuilder
    func subOrderGoods(goods: OrderItem) -> some View {
        VStack {
            HStack() {
                if goodsViewModel.isGoodsDetailLoading {
                    Color("main-shape-bkg-color")
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 1)
                } else {
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
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text(goodsViewModel.goodsDetail.title)
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
                        Text(goodsViewModel.goodsDetail.seller.name)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("point-color"))
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Text("\(goods.price * goods.quantity)원")
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
                showOrderCompleteView = true
            } label: {
                HStack {
                    Spacer()
                    
                    if loginViewModel.isLoading {
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
                showOrderCompleteView = true
            } label: {
                HStack {
                    Spacer()
                    
                    if loginViewModel.isLoading {
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
                        .foregroundColor(isValidBuyerName && isValidPhoneNumber && isValidPostalNumber && isValidAddress1 ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
                }
            }
            .disabled(!isValidBuyerName || !isValidPhoneNumber || !isValidPostalNumber || !isValidAddress1)
            .padding([.horizontal, .bottom])
            .padding(.bottom, 20)
        }
    }
    
    @ViewBuilder
    func orderCompleteView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color("shape-bkg-color"))
                    .frame(height: 10)
                
                Text("상품 주문이 완료되었습니다.")
                    .font(.title3)
                    .padding(.top)
                
                Text("입금 기한: \(limitDate) 까지")
                    .foregroundColor(Color("main-highlight-color"))
                    .padding(.vertical)
                    .onAppear() {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy.MM.dd HH시 mm분"
                        limitDate = formatter.string(from: .now.addingTimeInterval(3600 * 24 * 2))
                    }
                
                LazyVGrid(columns: columns) {
                    ForEach(orderGoods, id: \.hashValue) { goods in
                        orderCompleteGoods(goods: goods)
                    }
                }
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("주문 내역 확인하기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("main-highlight-color"))
                    }
                }
                .padding([.horizontal, .bottom])
                .padding(.vertical, 20)
                .padding(.top, 20)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showOrderCompleteView = false
                } label: {
                    Label("닫기", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .font(.footnote)
                        .foregroundColor(Color("main-text-color"))
                }
            }
        }
        .overlay(alignment: .bottom) {
        }
    }
    
    @ViewBuilder
    func orderCompleteGoods(goods: OrderItem) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 10)
                       
            subOrderGoods(goods: goods)
            
            Group {
                orderCompleteInfo(title: "예금주명", content: "김세종")
                
                orderCompleteInfo(title: "입금은행", content: "국민은행")
                
                orderCompleteInfo(title: "계좌번호", content: "304102-02-175615")
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func orderCompleteInfo(title: String, content: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Color("secondary-text-color-strong"))
                .frame(minWidth: 100)
            
            Text(content)
                .foregroundColor(Color("main-text-color"))
                .textSelection(.enabled)
            
            Spacer()
        }
        .padding(.vertical)
        .background(alignment: .bottom) {
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView(isPresented: .constant(false), orderGoods: [OrderItem(color: "블랙", size: "M", quantity: 1, price: 85000)])
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
    }
}
