//
//  CartView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/13.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @State private var isAllSelected: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            allSeletionAndDeleteSeleted()
            
            Rectangle()
                .fill(Color("shape-bkg-color"))
                .frame(height: 10)
            
            cartGoodsList()
        }
        .background(.white)
        .overlay(alignment: .bottom) {
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("\(goodsViewModel.selectedCartGoodsPrice)원 결제하기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
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
    
    @ViewBuilder
    func allSeletionAndDeleteSeleted() -> some View {
        HStack {
            Button {
                withAnimation {
                    isAllSelected.toggle()
                    
                    if isAllSelected {
                        goodsViewModel.cart.forEach { goods in
                            goodsViewModel.cartGoodsSelections.updateValue(true, forKey: goods.id)
                        }
                    } else {
                        goodsViewModel.cart.forEach { goods in
                            goodsViewModel.cartGoodsSelections.updateValue(false, forKey: goods.id)
                        }
                    }
                    
                    goodsViewModel.updateCartData()
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
                withAnimation(.spring()) {
                    goodsViewModel.isCartGoodsListLoading = true
                    
                    goodsViewModel.cart.forEach { goods in
                        if let isSeleted = goodsViewModel.cartGoodsSelections[goods.id], isSeleted {
                            goodsViewModel.deleteCartGoods(id: goods.id, token: loginViewModel.returnToken())
                        }
                    }
                    
                    goodsViewModel.cartGoodsSelections.removeAll()
                    
                    goodsViewModel.isCartGoodsListLoading = false
                }
            } label: {
                Text("선택 삭제")
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
            }
            
        }
        .padding()
    }
    
    @ViewBuilder
    func cartGoodsList() -> some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(goodsViewModel.cart, id: \.id) { goods in
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
                    withAnimation {
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
                
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(goods.title)
                                .foregroundColor(Color("main-text-color"))
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.spring()) {
                                    goodsViewModel.deleteCartGoods(id: goods.id, token: loginViewModel.returnToken())
                                }
                            } label: {
                                Label("삭제", systemImage: "xmark")
                                    .labelStyle(.iconOnly)
                                    .frame(minWidth: 21, minHeight: 21)
                                    .foregroundColor(Color("main-text-color"))
                            }
                            .unredacted()
                        }
                        
                        HStack {
                            if let color = goods.color, let size = goods.size {
                                Text("\(color), \(size)")
                            } else {
                                Text("\(goods.color ?? "")\(goods.size ?? "")")
                            }
                            
                            Spacer()
                        }
                        .font(.caption.bold())
                        .foregroundColor(Color("main-text-color"))
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                goodsViewModel.updateCartGoods(id: goods.id, quantity: goods.quantity - 1, token: loginViewModel.returnToken())
                            }
                        } label: {
                            Label("마이너스", systemImage: "minus")
                                .labelStyle(.iconOnly)
                                .font(.caption2)
                                .foregroundColor(Color("main-text-color"))
                        }
                        .disabled(goods.quantity <= 1)
                        .frame(minWidth: 21, minHeight: 21)
                        .background(Circle().fill(Color("shape-bkg-color")))
                        .opacity(goods.quantity <= 1 ? 0.7 : 1)
                        .unredacted()
                        
                        Text("\(goods.quantity)")
                            .font(.footnote)
                            .fontWeight(.light)
                        
                        Button {
                            withAnimation {
                                goodsViewModel.updateCartGoods(id: goods.id, quantity: goods.quantity + 1, token: loginViewModel.returnToken())
                            }
                        } label: {
                            Label("플러스", systemImage: "plus")
                                .labelStyle(.iconOnly)
                                .font(.caption2)
                                .foregroundColor(Color("main-text-color"))
                        }
                        .frame(minWidth: 21, minHeight: 21)
                        .background(Circle().fill(Color("shape-bkg-color")))
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
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
    }
}
