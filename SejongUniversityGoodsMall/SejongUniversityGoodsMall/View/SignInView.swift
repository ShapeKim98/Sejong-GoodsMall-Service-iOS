//
//  SignInView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/30.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @FocusState private var currentField: FocusedTextField?
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isFindView: Bool = false
    
    var body: some View {
        VStack {
            TextField("이메일", text: $email, prompt: Text("이메일"))
                .modifier(TextFieldModifier(text: $email, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .emailAddress, contentType: .emailAddress, focusedTextField: .emailField, submitLabel: .next))
                .onTapGesture {
                    currentField = .emailField
                }
                .onSubmit {
                    currentField = .passwordField
                }
                .padding(.vertical)
            
            SecureField("비밀번호", text: $password, prompt: Text("비밀번호"))
                .modifier(TextFieldModifier(text: $password, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .password, focusedTextField: .passwordField, submitLabel: .done))
                .onTapGesture {
                    currentField = .passwordField
                }
                .onSubmit {
                    if email != "" && password != "" {
                        loginViewModel.signIn(email: email, password: password)
                    }
                }
                .padding(.bottom)
            
            NavigationLink(isActive: $isFindView) {
                FindEmailPasswordView()
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
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("로그인")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .disabled(email == "" || password == "")
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor((email != "" && password != "") && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("shape-bkg-color"))
            }
            .padding(.bottom, 20)
        }
        .padding()
        .background(.white)
        .onTapGesture {
            currentField = nil
        }
        .modifier(FindEmailCompleteSheetModifer(isFindView: $isFindView))
    }
    
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(LoginViewModel())
    }
}
