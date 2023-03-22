//
//  AppView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

struct AppView: View {
    @Namespace var heroTransition
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    @State private var showMessage: Bool = false
    @State private var message: String = ""
    @State private var currentCategory: Category = Category(id: 0, name: "ALLPRODUCT")
    
    var body: some View {
        HomeView(currentCategory: $currentCategory)
            .onAppear() {
                withAnimation(.easeInOut) {
                    goodsViewModel.isGoodsListLoading = true
                }
                goodsViewModel.fetchGoodsList(token: loginViewModel.isAuthenticate ? loginViewModel.returnToken() : nil)
                
                withAnimation(.easeInOut) {
                    goodsViewModel.isCategoryLoading = true
                }
                goodsViewModel.fetchCategory()
            }
            .onChange(of: loginViewModel.message, perform: { newValue in
                if let msg = newValue {
                    message = msg
                    showMessage = true
                }
            })
            .onChange(of: goodsViewModel.message, perform: { newValue in
                if let msg = newValue {
                    message = msg
                    showMessage = true
                }
            })
            .alert(message, isPresented: $showMessage) {
                Button("확인") {
                    loginViewModel.message = nil
                    if goodsViewModel.message != nil {
                        goodsViewModel.message = nil
                    }
                }
            }
            .fullScreenCover(isPresented: $loginViewModel.showLoginView) {
                LoginView()
                    .onChange(of: loginViewModel.message, perform: { newValue in
                        if let msg = newValue {
                            message = msg
                            showMessage = true
                        }
                    })
                    .alert(message, isPresented: $showMessage) {
                        Button("확인") {
                            loginViewModel.message = nil
                        }
                    }
                    .onDisappear() {
                        withAnimation(.easeInOut) {
                            loginViewModel.isSignInFail = false
                            goodsViewModel.isGoodsListLoading = true
                        }
                        
                        if currentCategory.id == 0 {
                            goodsViewModel.fetchGoodsList(token: loginViewModel.isAuthenticate ? loginViewModel.returnToken() : nil)
                        } else {
                            goodsViewModel.fetchGoodsListFromCatefory(id: currentCategory.id)
                        }
                        
                        goodsViewModel.fetchCategory()
                        loginViewModel.isUserConfirm = false
                    }
                    .overlay {
                        if let errorView = loginViewModel.errorView {
                            errorView
                        }
                    }
            }
            .overlay {
                if let errorView = goodsViewModel.errorView {
                    errorView
                        .transition(.opacity.animation(.easeInOut))
                }
                
                if let errorView = loginViewModel.errorView {
                    errorView
                        .transition(.opacity.animation(.easeInOut))
                }
            }
            .onChange(of: networkManager.isConnected) { newValue in
                if !newValue {
                    goodsViewModel.errorView = ErrorView(retryAction: {}, closeAction: {})
                    loginViewModel.errorView = ErrorView(retryAction: {}, closeAction: {})
                } else {
                    goodsViewModel.errorView = nil
                    loginViewModel.errorView = nil
                }
            }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(AppViewModel())
            .environmentObject(GoodsViewModel())
            .environmentObject(LoginViewModel())
            .environmentObject(NetworkManager())
    }
}
