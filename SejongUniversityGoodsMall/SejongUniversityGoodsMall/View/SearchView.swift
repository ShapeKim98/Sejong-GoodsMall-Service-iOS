//
//  SearchView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/18.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var searchText: String = ""
    @FocusState private var searchingFocused: Bool
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading) {
                HStack {
                    Text("최근 검색어")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-text-color"))
                    
                    Spacer()
                    
                    Button("전체삭제", role: .destructive) {
                        //                    recentSearches.removeAll()
                    }
                    .font(.footnote)
                    .foregroundColor(Color("main-highlight-color"))
                }
                .padding()
                .padding(.horizontal, 5)
                
                VStack {
                    //                ForEach(recentSearches, id: \.hashValue) { keyword in
                    //                    HStack {
                    //                        Button {
                    //
                    //                        } label: {
                    //                            HStack(spacing: 20) {
                    //                                Label("검색어", systemImage: "magnifyingglass")
                    //                                    .labelStyle(.iconOnly)
                    //                                    .foregroundColor(Color("main-text-color").opacity(0.7))
                    //                                    .padding(8)
                    //                                    .background {
                    //                                        Circle()
                    //                                            .foregroundColor(Color("shape-bkg-color"))
                    //                                    }
                    //
                    //                                Text(keyword)
                    //                                    .foregroundColor(Color("main-text-color"))
                    //
                    //                                Spacer()
                    //                            }
                    //                        }
                    //
                    //                        Button(role: .destructive) {
                    //
                    //                        } label: {
                    //                            Label("삭제", systemImage: "xmark")
                    //                                .labelStyle(.iconOnly)
                    //                        }
                    //                    }
                    //                    .padding(.horizontal)
                    //                    .padding(.vertical, 5)
                    //                }
                }
                .foregroundColor(Color("main-text-color"))
                .padding(.horizontal, 5)
                
                Spacer()
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
                                //                            recentSearches.insert(searchText, at: 0)
                            }
                            .focused($searchingFocused)
                        
                        Spacer()
                        
                        if searchText != "" {
                            Button {
                                withAnimation {
                                    searchText = ""
                                }
                            } label: {
                                Label("삭제", systemImage: "xmark.circle.fill")
                                    .font(.headline.bold())
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
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}
