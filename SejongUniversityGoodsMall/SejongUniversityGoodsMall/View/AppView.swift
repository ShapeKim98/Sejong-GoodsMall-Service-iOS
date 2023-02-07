//
//  AppView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/19.
//

import SwiftUI

struct AppView: View {
    @Namespace var heroTransition
    
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State var showMessage: Bool = false
    @State var message: String = ""
    
    var body: some View {
        if loginViewModel.isSignUpComplete || loginViewModel.isAuthenticate {
            HomeView()
                .onAppear() {
                    goodsViewModel.fetchGoodsList()
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
                            goodsViewModel.fetchGoodsList()
                        }
                    }
                }
        } else {
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
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
            .environmentObject(LoginViewModel())
    }
}
