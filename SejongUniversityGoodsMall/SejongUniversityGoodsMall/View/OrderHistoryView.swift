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
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    private let formatter = DateFormatter()
    
    init() {
        self.formatter.dateFormat = "yyyyMMddHHmmss"
    }
    
    var body: some View {
        VStack {
            if goodsViewModel.isOrderGoodsListLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .tint(Color("main-highlight-color"))
                    .unredacted()
            } else {
                ScrollView {
                    orderHistoryList()
                }
            }

            Spacer()
        }
        .background(.white)
    }
    
    @ViewBuilder
    func orderDateHeader(date: Date) -> some View {
        let dateString = formatter.string(from: date)
        
        HStack {
            Text(dateString)
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
            
            Spacer()
        }
        .background(.white)
    }
    
    @ViewBuilder
    func orderHistoryList() -> some View {
        LazyVGrid(columns: columns) {
            ForEach(goodsViewModel.orderCompleteGoodsList) { orderCompleteGoods in
                Rectangle()
                    .fill(Color("shape-bkg-color"))
                    .frame(height: 10)

                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        ForEach(orderCompleteGoods.orderItems, id:\.hashValue) { goods in
                            subOrderGoods(orderCompleteGoods: orderCompleteGoods, goods: goods)
                            
                            orderCompleteInfo(title: <#T##String#>, content: <#T##String#>)
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
                            Text("수량 \(goods.quantity)개")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("secondary-text-color"))
                            
                            Spacer()
                        }
                        .padding(.bottom, 5)
                        
                        HStack {
                            Text("\(goods.price)원")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(Color("main-text-color"))
                            
                            Spacer()
                        }
                    }
                    .padding(10)
                }
                .padding(.vertical)
            } else {
                HStack() {
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
        }
        .padding(.vertical)
        .background(alignment: .bottom) {
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
        }
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
