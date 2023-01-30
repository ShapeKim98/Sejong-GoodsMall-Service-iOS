//
//  SignInView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/30.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var isAuthenticate: Bool = false
    @State private var email: String = ""
    @State private var password: String = ""
    
    init() {
        if #available(iOS 16.0, *) {

        } else {
            SetNavigationBarColor.navigationBarColors(background: .white, titleColor: UIColor(Color("main-text-color")))
        }
    }
    
    var body: some View {
        VStack {
            TextField("이메일", text: $email, prompt: Text("이메일"))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .padding()
                .background {
                    textFieldBackground(input: email)
                }
                .padding(.vertical)
            
            SecureField("비밀번호", text: $password, prompt: Text("비밀번호"))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.password)
                .padding()
                .background {
                    textFieldBackground(input: email)
                }
                .padding(.bottom)
            
            Button {
                
            } label: {
                Text("이메일/비밀번호 찾기")
                    .font(.footnote)
                    .fontWeight(.bold)
            }
            .foregroundColor(Color("main-highlight-color"))

            
            Spacer()
            
            Button {
                loginViewModel.signIn(email: email, password: password)
            } label: {
                HStack {
                    Spacer()
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        Text("로그인")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .disabled((email == "" || password == "") || loginViewModel.isLoading)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor((email != "" && password != "") && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("shape-bkg-color"))
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
    
    @ViewBuilder
    func textFieldBackground(input: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(Color("shape-bkg-color"))
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(LoginViewModel())
    }
}
