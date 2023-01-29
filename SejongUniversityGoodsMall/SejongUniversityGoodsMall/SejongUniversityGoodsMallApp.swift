//
//  SejongUniversityGoodsMallApp.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

@main
struct SejongUniversityGoodsMallApp: App {
    @StateObject var sampleGoodsViewModel: SampleGoodsViewModel = SampleGoodsViewModel()
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(sampleGoodsViewModel)
                .environmentObject(loginViewModel)
                .preferredColorScheme(.light)
        }
    }
}
