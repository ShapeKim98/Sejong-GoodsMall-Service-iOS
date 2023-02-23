//
//  NavigationPopModifier.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/21.
//

import SwiftUI

struct ShowOrderViewModifier<V>: ViewModifier where V: View {
    @Binding var isPresented: Bool
    var destination: () -> V
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .navigationDestination(isPresented: $isPresented, destination: destination)
        } else {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    NavigationView {
                        destination()
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        isPresented = false
                                    } label: {
                                        Label("닫기", systemImage: "xmark")
                                            .labelStyle(.iconOnly)
                                            .font(.footnote)
                                            .foregroundColor(Color("main-text-color"))
                                    }
                                }
                            }
                            .navigationTitle("주문서 작성")
                            .navigationBarTitleDisplayMode(.inline)
                            .modifier(NavigationColorModifier())
                    }
                }
        }
    }
}
