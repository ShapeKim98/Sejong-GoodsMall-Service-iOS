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
    
    var body: some View {
        VStack {
            ScrollView {
                orderHistoryList()
            }
            
            Spacer()
        }
        .background(.white)
        .navigationTitle("주문 내역")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func orderDateHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .padding()
            
            Spacer()
        }
        .background(.white)
    }
    
    @ViewBuilder
    func orderHistoryList() -> some View {
        VStack {
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 10)
            
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(goodsViewModel.pickUpCart) { goods in
                        subOrderGoods(goods: goods)
                    }
                } header: {
                    orderDateHeader(title: "주문일자 : 202302171055")
                }
            }
        }
    }
    
    @ViewBuilder
    func subOrderGoods(goods: CartGoodsResponse) -> some View {
        VStack {
            HStack {
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
                        
                        Text("이체확인")
                            .font(.subheadline)
                            .foregroundColor(Color("main-highlight-color"))
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
