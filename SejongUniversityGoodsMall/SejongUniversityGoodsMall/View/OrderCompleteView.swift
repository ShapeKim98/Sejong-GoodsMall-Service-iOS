//
//  OrderCompleteView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/01.
//

import SwiftUI

struct OrderCompleteView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State private var limitDate: String = ""
    @State private var showOrderHistory: Bool = false
    @State private var showOrderCompleteText: Bool = false
    @State private var showLimitDate: Bool = false
    @State private var showOrderCompleteList: Bool = false
    @State private var copyClipBoardComplete: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    init() {
        if #available(iOS 16.0, *) {
            
        } else {
            SetNavigationBarColor.navigationBarColors(background: .white, titleColor: UIColor(Color("main-text-color")))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            orderComplete()
            
            if showOrderCompleteList {
                Rectangle()
                    .fill(Color("shape-bkg-color"))
                    .frame(height: 10)
                
                ScrollView {
                    orderCompleteGoodsList()
                        .transition(.opacity)
                    
                    orderHistoryButton()
                        .transition(.opacity)
                }
                .overlay(alignment: .bottom) {
                    if copyClipBoardComplete {
                        copyClipBoardView()
                            .padding(.bottom, 40)
                            .onAppear() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation(.easeInOut) {
                                        copyClipBoardComplete = false
                                    }
                                }
                            }
                    }
                }
            }
        }
        .background(.white)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()) {
                    showOrderCompleteText = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.spring()) {
                    showLimitDate = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showOrderCompleteList = true
                }
            }
        }
    }
    
    @ViewBuilder
    func orderComplete() -> some View {
        VStack {
            if showOrderCompleteList {
                Rectangle()
                    .fill(Color("shape-bkg-color"))
                    .frame(height: 10)
            }
            
            if showOrderCompleteText {
                Text("상품 주문이 완료되었습니다.")
                    .font(showLimitDate ? .title3 : .title)
                    .foregroundColor(Color("main-text-color"))
                    .padding(.top)
                    .transition(.opacity)
            }
            
            if showLimitDate {
                Text("입금 기한: \(limitDate) 까지")
                    .font(showOrderCompleteList ? nil : .title2)
                    .foregroundColor(Color("main-highlight-color"))
                    .padding(.vertical)
                    .onAppear() {
                        if let date = goodsViewModel.orderCompleteGoods?.createdAt {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy.MM.dd HH시 mm분"
                            limitDate = formatter.string(from: date.addingTimeInterval(3600 * 24 * 2 + 3600 * 9))
                        }
                    }
                    .transition(.opacity)
            }
        }
    }
    
    @ViewBuilder
    func orderCompleteGoodsList() -> some View {
        LazyVGrid(columns: columns) {
            if let orderCompleteGoods = goodsViewModel.orderCompleteGoods {
                ForEach(orderCompleteGoods.orderItems, id: \.hashValue) { goods in
                    VStack(spacing: 0) {
                        subOrderGoods(goods: goods)
                        
                        if let seller = goods.seller {
                            Group {
                                orderCompleteInfo(title: "예금주", content: seller.accountHolder)
                                
                                orderCompleteInfo(title: "입금은행", content: seller.bank)
                                
                                orderCompleteInfo(title: "계좌번호", content: seller.account)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func subOrderGoods(goods: OrderItem) -> some View {
        VStack {
            if let id = goods.itemID, let info = goodsViewModel.orderGoodsInfoList[id] {
                HStack() {
                    if let image = info.representativeImage() {
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
                            Text(info.title)
                                .foregroundColor(Color("main-text-color"))
                                .padding(.trailing)
                            
                            Spacer()
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
                        .padding(.bottom, 5)
                        
                        HStack {
                            Text(info.seller.name)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("point-color"))
                            
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            Text("\(goods.price)원")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color("main-text-color"))
                            
                            Spacer()
                            
                            Text("수량 \(goods.quantity)개")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("secondary-text-color"))
                        }
                    }
                    .padding(10)
                }
                .padding(.vertical)
            } else {
                HStack {
                    Spacer()
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .controlSize(.regular)
                        .padding()
                        .tint(Color("main-highlight-color"))
                    
                    Spacer()
                }
            }
            
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
        .padding(.horizontal)
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
            
            if title == "계좌번호" {
                Button {
                    UIPasteboard.general.string = content
                    withAnimation(.easeInOut) {
                        copyClipBoardComplete = true
                    }
                } label: {
                    Label("클립보드", systemImage: "doc.on.clipboard.fill")
                        .labelStyle(.iconOnly)
                        .foregroundColor(Color("secondary-text-color-strong"))
                }
            }
        }
        .padding(.vertical)
        .background(alignment: .bottom) {
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
    }
    
    @ViewBuilder
    func orderHistoryButton() -> some View {
        NavigationLink {
            OrderHistoryView()
                .navigationTitle("주문 내역")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
                .onAppear() {
                    withAnimation(.easeInOut) {
                        goodsViewModel.isOrderGoodsListLoading = true
                    }
                    
                    goodsViewModel.fetchOrderGoodsList(token: loginViewModel.returnToken())
                }
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
    
    @ViewBuilder
    func copyClipBoardView() -> some View {
        HStack {
            Spacer()
            
            Text("클립보드에 복사 되었습니다.")
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

struct OrderCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCompleteView()
        .environmentObject(GoodsViewModel())
        .environmentObject(LoginViewModel())
    }
}
