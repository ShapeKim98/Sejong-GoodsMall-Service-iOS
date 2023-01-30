//
//  LoginView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/27.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        GeometryReader { reader in
            if #available(iOS 16.0, *) {
                NavigationStack {
                    VStack {
                        title()
                        
                        Spacer()
                        
                        buttons()
                    }
                    .navigationTitle("")
                    .navigationBarBackButtonHidden()
                }
                .tint(Color("main-text-color"))
            } else {
                NavigationView {
                    VStack {
                        title()
                        
                        Spacer()
                        
                        buttons()
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                }
            }
        }
    }
    
    @ViewBuilder
    func title() -> some View {
        HStack {
            Text("앱 설명 & 이름 & 로고(?)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color("main-text-color"))
            
            Spacer()
        }
        .padding(.top)
        .padding()
    }
    
    @ViewBuilder
    func buttons() -> some View {
        VStack {
            NavigationLink {
                SignUpView()
                    .navigationTitle("이메일로 가입하기")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
                    .environmentObject(loginViewModel)
            } label: {
                HStack {
                    Spacer()
                    
                    Text("이메일로 가입하기")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("main-highlight-color"))
            }
            
            NavigationLink {
                SignInView()
                    .navigationTitle("기존 계정으로 로그인")
                    .navigationBarTitleDisplayMode(.inline)
                    .environmentObject(loginViewModel)
            } label: {
                HStack {
                    Spacer()
                    
                    Text("기존 계정으로 로그인")
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-highlight-color"))
                        .padding()
                    
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("main-highlight-color"))
            }
        }
        .padding()
        .padding(.bottom, 20)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LoginViewModel())
    }
}
