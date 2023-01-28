//
//  AppView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

struct AppView: View {
    @Namespace var heroTransition
    
    @EnvironmentObject var sampleGoodsViewModel: SampleGoodsViewModel
    
    @State private var showLoginView: Bool = true
    
    var body: some View {
        if showLoginView {
            LoginView()
        } else {
            HomeView()
                .environmentObject(sampleGoodsViewModel)
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(SampleGoodsViewModel())
    }
}
