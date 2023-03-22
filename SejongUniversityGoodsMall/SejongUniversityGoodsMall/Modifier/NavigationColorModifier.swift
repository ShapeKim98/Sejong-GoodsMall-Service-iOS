//
//  NavigationColorModifier.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/22.
//

import SwiftUI

struct NavigationColorModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbarBackground(.white, for: .navigationBar)
        } else {
            content
        }
    }
}
