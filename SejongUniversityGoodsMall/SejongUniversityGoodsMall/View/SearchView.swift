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
                VStack {
                    
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
