//
//  NavigationPopModifier.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/21.
//

import SwiftUI

struct NavigationPopModifierr<V>: ViewModifier where V: View {
    @Binding var isPresented: Bool
    var destination: () -> V
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .navigationDestination(isPresented: $isPresented, destination: destination)
        } else {
            content
        }
    }
}
