//
//  OrderHistory.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/20.
//

import SwiftUI

struct OrderHistoryView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State private var showOrderDetaiView: Bool = false
    @State private var copyClipBoardComplete: Bool = false
    @State private var currentOrderCompleteGoods: OrderGoodsRespnose?
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    private let formatter = DateFormatter()
    
    init() {
        self.formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
    }
    
    var body: some View {
        VStack {
            if goodsViewModel.isOrderGoodsListLoading {
                Spacer()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
                    .padding()
                    .tint(Color("main-highlight-color"))
                    .unredacted()
                
                Spacer()
            } else {
                ScrollView {
                    Rectangle()
                        .fill(Color("shape-bkg-color"))
                        .frame(height: 10)
                    
                    orderHistoryList()
                }
            }
        }
        .background(.white)
        .onDisappear() {
            goodsViewModel.orderGoodsInfoList.removeAll()
        }
        .fullScreenCover(isPresented: $showOrderDetaiView) {
            if #available(iOS 16.0, *) {
                NavigationStack {
                        orderDetail(orderCompleteGoods: currentOrderCompleteGoods)
                            .navigationTitle("주문 상세 내역")
                            .navigationBarTitleDisplayMode(.inline)
                            .modifier(NavigationColorModifier())
                }
            } else {
                NavigationView {
                        orderDetail(orderCompleteGoods: currentOrderCompleteGoods)
                            .navigationTitle("주문 상세 내역")
                            .navigationBarTitleDisplayMode(.inline)
                            .modifier(NavigationColorModifier())
                }
            }
        }
    }
    
    @ViewBuilder
    func orderDateHeader(date: Date) -> some View {
        let dateString = formatter.string(from: date.addingTimeInterval(3600 * 9))
        let limitDate = formatter.string(from: date.addingTimeInterval(3600 * 11))
        
        VStack {
            HStack {
                Text("주문일자 : \(dateString)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding([.horizontal, .top])
                    .padding(.bottom, 10)
                
                Spacer()
            }
            
            HStack {
                Text("입금 기한: \(limitDate) 까지")
                    .font(.headline)
                    .foregroundColor(Color("main-highlight-color"))
                    .padding([.horizontal, .bottom])
                
                Spacer()
            }
        }
        .background(.white)
    }
    
    @ViewBuilder
    func orderHistoryList() -> some View {
        LazyVGrid(columns: columns) {
            ForEach(goodsViewModel.orderCompleteGoodsList) { orderCompleteGoods in
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(orderCompleteGoods.orderItems, id:\.hashValue) { goods in
                            Button {
                                currentOrderCompleteGoods = orderCompleteGoods
                                
                                showOrderDetaiView = true
                            } label: {
                                subOrderGoods(orderCompleteGoods: orderCompleteGoods, goods: goods)
                            }
                        }
                    } header: {
                        orderDateHeader(date: orderCompleteGoods.createdAt)
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder
    func subOrderGoods(orderCompleteGoods: OrderGoodsRespnose, goods: OrderItem) -> some View {
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
                            
                            Text(goods.orderStatus?.kor ?? "")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("main-highlight-color"))
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
    func orderDetail(orderCompleteGoods: OrderGoodsRespnose?) -> some View {
        ScrollView {
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 10)
            
            if let orderGoods = orderCompleteGoods {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(orderGoods.orderItems, id:\.hashValue) { goods in
                            subOrderGoods(orderCompleteGoods: orderGoods, goods: goods)
                            
                            VStack(spacing: 0) {
                                Group {
                                    if let seller = goods.seller {
                                        Group {
                                            orderCompleteInfo(title: "예금주", content: seller.accountHolder)
                                            
                                            orderCompleteInfo(title: "입금은행", content: seller.bank)
                                            
                                            orderCompleteInfo(title: "계좌번호", content: seller.account)
                                        }
                                    }
                                    
                                    Group {
                                        orderCompleteInfo(title: "수령인", content: orderGoods.buyerName)
                                        
                                        orderCompleteInfo(title: "휴대전화", content: orderGoods.phoneNumber)
                                    }
                                    
                                    if let address = orderGoods.address {
                                        Group {
                                            orderCompleteInfo(title: "우편번호", content: address.zipcode)
                                            
                                            orderCompleteInfo(title: "주소", content: address.mainAddress)
                                            
                                            orderCompleteInfo(title: "상세주소", content: address.detailAddress ?? "없습니다.")
                                            
                                            orderCompleteInfo(title: "요청사항", content: orderGoods.deliveryRequest ?? "없습니다.")
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } header: {
                        orderDateHeader(date: orderGoods.createdAt)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showOrderDetaiView = false
                } label: {
                    Label("닫기", systemImage: "xmark")
                        .labelStyle(.iconOnly)
                        .font(.footnote)
                        .foregroundColor(Color("main-text-color"))
                }
            }
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

struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderHistoryView()
                .environmentObject(LoginViewModel())
                .environmentObject(GoodsViewModel())
        }
    }
}
