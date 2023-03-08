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
    
    @Binding var showDatePicker: Bool
    @Binding var userBirth: String
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isFindView: Bool = false
    @State private var vibrateOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            TextField("이메일", text: $email, prompt: Text("이메일"))
                .modifier(TextFieldModifier(text: $email, isValidInput: .constant(loginViewModel.isSignInFail ? false : true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .emailAddress, contentType: .emailAddress, focusedTextField: .emailField, submitLabel: .next))
                .onTapGesture {
                    currentField = .emailField
                }
                .onSubmit {
                    currentField = .passwordField
                }
                .modifier(VibrateAnimation(animatableData: vibrateOffset))
            
            
            SecureField("비밀번호", text: $password, prompt: Text("비밀번호"))
                .modifier(TextFieldModifier(text: $password, isValidInput: .constant(loginViewModel.isSignInFail ? false : true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .password, focusedTextField: .passwordField, submitLabel: .done))
                .onTapGesture {
                    currentField = .passwordField
                }
                .onSubmit {
                    if email != "" && password != "" {
                        loginViewModel.signIn(email: email, password: password)
                    }
                }
                .modifier(VibrateAnimation(animatableData: vibrateOffset))
            
            HStack {
                Text(loginViewModel.isSignInFail ? "이메일 또는 비밀번호가 일치하지 않습니다." : " ")
                    .font(.caption2)
                    .foregroundColor(Color("main-highlight-color"))
                
                Spacer()
            }
            .padding(.horizontal)
            
            NavigationLink(isActive: $isFindView) {
                FindEmailPasswordView(showDatePicker: $showDatePicker, userBirth: $userBirth)
            } label: {
                Text("이메일/비밀번호 찾기")
                    .font(.footnote)
                    .fontWeight(.bold)
            }
            .foregroundColor(Color("main-highlight-color"))
            .padding(.top)
            
            Spacer()
            
            Button {
                loginViewModel.isLoading = true
                withAnimation(.easeInOut) {
                    loginViewModel.isSignInFail = false
                }
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
                    .foregroundColor((email != "" && password != "") && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: 500)
        .padding()
        .background(.white)
        .onTapGesture {
            currentField = nil
        }
        .onChange(of: loginViewModel.isSignInFail) { newValue in
            withAnimation(.spring()) {
                vibrateOffset += newValue ? 1 : 0
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(showDatePicker: .constant(false), userBirth: .constant(""))
            .environmentObject(LoginViewModel())
    }
}
