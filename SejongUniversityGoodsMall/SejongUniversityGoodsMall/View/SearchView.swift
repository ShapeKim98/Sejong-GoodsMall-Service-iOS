//
//  SearchView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/18.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var searchText: String = ""
    @FocusState private var searchingFocused: Bool
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    var body: some View {
        GeometryReader { reader in
            VStack {
                if goodsViewModel.isSearchLoading {
                    HStack {
                        Spacer()
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .controlSize(.large)
                            .padding()
                            .tint(Color("main-highlight-color"))
                            .unredacted()
                        
                        Spacer()
                    }
                    
                    Spacer()
                } else {
                    goodList()
                }
            }
            .background(.white)
            .onTapGesture {
                searchingFocused = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Label("검색", systemImage: "magnifyingglass")
                            .labelStyle(.iconOnly)
                            .foregroundColor(Color("main-text-color").opacity(0.7))
                        
                        TextField("검색", text: $searchText, prompt: Text("상품을 검색해주세요").font(.footnote).foregroundColor(Color("main-text-color").opacity(0.7)))
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .keyboardType(.default)
                            .submitLabel(.search)
                            .onSubmit {
                                goodsViewModel.isSearchLoading = true
                                withAnimation(.easeInOut) {
                                    goodsViewModel.searchGoods(searchText: searchText)
                                }
                            }
                            .focused($searchingFocused)
                        
                        Spacer()
                        
                        if searchText != "" {
                            Button {
                                withAnimation(.easeInOut) {
                                    searchText = ""
                                }
                            } label: {
                                Label("삭제", systemImage: "xmark.circle.fill")
                                    .font(.footnote.bold())
                                    .labelStyle(.iconOnly)
                                    .foregroundColor(Color("secondary-text-color"))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("shape-bkg-color"))
                    }
                    .padding(.horizontal, 5)
                    .frame(minWidth: reader.size.width - 100)
                }
                
                ToolbarItem {
                    Button("취소") {
                        dismiss()
                    }
                    .padding(.horizontal, 5)
                    .foregroundColor(Color("secondary-text-color"))
                }
            }
            .onDisappear() {
                goodsViewModel.searchList.removeAll()
            }
        }
    }
    
    @ViewBuilder
    func goodList() -> some View {
        if #available(iOS 16.0, *) {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(goodsViewModel.searchList) { item in
                        subGoodsView(item)
                    }
                    .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                }
                .padding(.top)
            }
            .refreshable {
                goodsViewModel.searchGoods(searchText: searchText)
            }
        } else {
            List(goodsViewModel.goodsList) { item in
                subGoodsView(item)
                    .redacted(reason: goodsViewModel.isGoodsListLoading ? .placeholder : [])
                    .listRowSeparatorTint(.clear)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding(.top)
            }
            .listStyle(.plain)
            .refreshable {
                goodsViewModel.searchGoods(searchText: searchText)
            }
        }
    }
    
    @ViewBuilder
    func subGoodsView(_ goods: Goods) -> some View {
        NavigationLink {
            GoodsDetailView()
                .onAppear(){
                    withAnimation(.easeInOut) {
                        goodsViewModel.isGoodsDetailLoading = true
                    }
                    goodsViewModel.fetchGoodsDetail(id: goods.id, token: loginViewModel.returnToken())
                }
                .navigationTitle("상품 정보")
                .navigationBarTitleDisplayMode(.inline)
                .modifier(NavigationColorModifier())
                .redacted(reason: goodsViewModel.isGoodsDetailLoading ? .placeholder : [])
        } label: {
            VStack {
                HStack(alignment: .top) {
                    if let image = goods.representativeImage() {
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
                        .frame(width: 115, height: 115)
                        .shadow(radius: 1)
                    } else {
                        Color("main-shape-bkg-color")
                            .frame(width: 115, height: 115)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(goods.title)
                                    .foregroundColor(Color("main-text-color"))
                                    .font(.subheadline)
                                
                                Spacer()
                            }
                            
                            switch goods.seller.method {
                                case .both:
                                    Text("현장수령, 택배수령")
                                        .font(.caption)
                                        .foregroundColor(Color("point-color"))
                                case .pickUp:
                                    Text("현장수령")
                                        .font(.caption)
                                        .foregroundColor(Color("point-color"))
                                case .delivery:
                                    Text("택배수령")
                                        .font(.caption)
                                        .foregroundColor(Color("point-color"))
                            }
                            
                            HStack(spacing: 3) {
                                if let description = goods.description {
                                    Text(description)
                                        .font(.caption)
                                        .foregroundColor(Color("secondary-text-color"))
                                }
                            }
                        }
                        
                        Text("\(goods.price)원")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 5)
                    
                    Spacer()
                }
                
                Rectangle()
                    .foregroundColor(Color("shape-bkg-color"))
                    .frame(height: 1)
                    .padding(.vertical, 5)
            }
        }
        .padding(.horizontal)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
                .environmentObject(GoodsViewModel())
                .environmentObject(LoginViewModel())
        }
    }
}
