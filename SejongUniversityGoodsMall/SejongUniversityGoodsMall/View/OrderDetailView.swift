//
//  OrderDetailView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/16.
//

import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State private var copyClipBoardComplete: Bool = false
    
    private let id: Int?
    private let formatter = DateFormatter()
    
    init(id: Int?) {
        self.id = id
    }
    
    var body: some View {
        ScrollView {
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 10)
            
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                if let orderCompleteGoods = goodsViewModel.orderCompleteGoodsList.first(where: {orderGoods in return orderGoods.id == id}) {
                    Section {
                        ForEach(orderCompleteGoods.orderItems, id:\.hashValue) { goods in
                            subOrderGoods(orderCompleteGoods: orderCompleteGoods, goods: goods)
                            
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
                                        orderCompleteInfo(title: "수령인", content: orderCompleteGoods.buyerName)
                                        
                                        orderCompleteInfo(title: "휴대전화", content: orderCompleteGoods.phoneNumber)
                                    }
                                    
                                    if let address = orderCompleteGoods.address {
                                        Group {
                                            orderCompleteInfo(title: "우편번호", content: address.zipcode)
                                            
                                            orderCompleteInfo(title: "주소", content: address.mainAddress)
                                            
                                            orderCompleteInfo(title: "상세주소", content: address.detailAddress ?? "없습니다.")
                                            
                                            orderCompleteInfo(title: "요청사항", content: orderCompleteGoods.deliveryRequest ?? "없습니다.")
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    } header: {
                        orderDateHeader(date: orderCompleteGoods.createdAt)
                    }
                }
            }
        }
        .onAppear() {
            self.formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
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
                            Text(info.seller.name)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("point-color"))
                            
                            Spacer()
                            
                            Text(orderCompleteGoods.status ?? "")
                                .font(.subheadline)
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
                    Color("main-shape-bkg-color")
                        .frame(width: 100, height: 100)
                        .shadow(radius: 1)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            
                            Text("PLACEHOLDER")
                                .foregroundColor(Color("main-text-color"))
                                .padding(.trailing)
                            
                            Group {
                                Text("PLACEHOLDER, PLACEHOLDER")
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
                            Text("PLACEHOLDER")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("point-color"))
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("\(999999)원")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color("main-text-color"))
                            
                            Spacer()
                            
                            Text("수량 \(0)개")
                                .font(.caption.bold())
                                .foregroundColor(Color("main-text-color"))
                        }
                    }
                    .padding(10)
                }
                .redacted(reason: .placeholder)
                .padding(.vertical)
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
    func orderDateHeader(date: Date) -> some View {
        let dateString = formatter.string(from: date.addingTimeInterval(3600 * 9))
        
        VStack {
            HStack {
                Text("주문일자 : \(dateString)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding()
                
                Spacer()
            }
        }
        .background(.white)
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
