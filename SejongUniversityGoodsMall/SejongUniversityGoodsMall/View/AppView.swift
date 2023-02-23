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
    
    @State var showMessage: Bool = false
    @State var message: String = ""
    
    var body: some View {
        HomeView()
            .onAppear() {
                goodsViewModel.fetchGoodsList(id: loginViewModel.memberID)
                goodsViewModel.fetchCategory(token: loginViewModel.returnToken())
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
            }
            .disabled(!networkManager.isConnected)
            .overlay {
                if !networkManager.isConnected {
                    ErrorView()
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
