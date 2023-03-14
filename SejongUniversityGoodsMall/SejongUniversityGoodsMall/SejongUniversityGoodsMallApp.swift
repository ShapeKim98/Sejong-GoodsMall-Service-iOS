//
//  SejongUniversityGoodsMallApp.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

@main
struct SejongUniversityGoodsMallApp: App {
    @StateObject var appViewModel: AppViewModel = AppViewModel()
    @StateObject var goodsViewModel: GoodsViewModel = GoodsViewModel()
    @StateObject var loginViewModel: LoginViewModel = LoginViewModel()
    @StateObject var networkManager: NetworkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .environmentObject(appViewModel)
                .environmentObject(goodsViewModel)
                .environmentObject(loginViewModel)
                .environmentObject(networkManager)
        }
    }
}
