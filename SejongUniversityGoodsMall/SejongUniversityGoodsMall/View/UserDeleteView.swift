//
//  UserDeleteView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/18.
//

import SwiftUI

struct UserDeleteView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    
    @FocusState private var currentField: FocusedTextField?
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var vibrateOffset: CGFloat = 0
    @State private var tapUserDeleteButton: Bool = false
    @State private var showCompleteTitle: Bool = false
    @State private var showCompleteContents: Bool = false
    
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    if loginViewModel.isUserDeleteComplete {
                        userDeleteComplete(action: action)
                    } else {
                        ScrollView {
                            VStack {
                                
                                subTitle()
                                
                                signIn()
                                
                                explain()
                                
                                userDeleteButton()
                            }
                        }
                    }
                }
                .onTapGesture {
                    currentField = nil
                }
                .onChange(of: loginViewModel.isSignInFail) { newValue in
                    withAnimation(.spring()) {
                        vibrateOffset += newValue ? 1 : 0
                    }
                }
                .navigationTitle(loginViewModel.isUserDeleteComplete ? "" : "회원탈퇴")
                .toolbar {
                    if !loginViewModel.isUserDeleteComplete {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                loginViewModel.isUserConfirm = false
                                dismiss()
                            } label: {
                                Label("닫기", systemImage: "xmark")
                                    .labelStyle(.iconOnly)
                                    .font(.footnote)
                                    .foregroundColor(Color("main-text-color"))
                            }
                        }
                    }
                }
            }
        } else {
            NavigationView {
                VStack {
                    if loginViewModel.isUserDeleteComplete {
                        userDeleteComplete(action: action)
                    } else {
                        ScrollView {
                            VStack {
                                
                                subTitle()
                                
                                signIn()
                                
                                explain()
                                
                                userDeleteButton()
                            }
                        }
                    }
                }
                .onChange(of: loginViewModel.isSignInFail) { newValue in
                    withAnimation(.spring()) {
                        vibrateOffset += newValue ? 1 : 0
                    }
                }
                .onTapGesture {
                    currentField = nil
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            loginViewModel.isUserConfirm = false
                            dismiss()
                        } label: {
                            Label("닫기", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                                .font(.footnote)
                                .foregroundColor(Color("main-text-color"))
                        }
                        .disabled(loginViewModel.isUserDeleteComplete)
                        .opacity(loginViewModel.isUserDeleteComplete ? 0 : 1)
                    }
                }
                .navigationTitle(loginViewModel.isUserDeleteComplete ? "" : "회원탈퇴")
            }
        }
    }
    
    @ViewBuilder
    func subTitle() -> some View {
        HStack {
            Text("정말 탈퇴하시겠어요?")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func explain() -> some View {
        HStack {
            Text("""
                계정을 삭제하면 회원님의 모든 주문내역과 활동내용을 포함한 모든 정보가 즉시 삭제됩니다. 삭제된 정보는 복구할 수 없으니 신중하게 결정해주세요.
                
                이미 주문한 상품이 있을 경우 자동으로 환불이 되지 않으며, 환불문의는 해당 상품의 판매자에게 문의해주세요.
                """)
        }
        .font(.caption)
        .foregroundColor(Color("main-highlight-color"))
        .padding()
    }
    
    @ViewBuilder
    func signIn() -> some View {
        VStack {
            HStack {
                Text("로그인 확인")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
            }
            
            TextField("이메일", text: $email, prompt: Text("이메일"))
                .modifier(TextFieldModifier(text: $email, isValidInput: .constant(!loginViewModel.isSignInFail), currentField: _currentField, font: .subheadline.bold(), keyboardType: .emailAddress, contentType: .emailAddress, focusedTextField: .emailField, submitLabel: .next))
                .onTapGesture {
                    currentField = .emailField
                }
                .onSubmit {
                    currentField = .passwordField
                }
                .onChange(of: email) { newValue in
                    withAnimation(.easeInOut) {
                        loginViewModel.isSignInFail = false
                    }
                }
                .overlay {
                    if loginViewModel.isUserConfirm {
                        HStack {
                            Spacer()
                            
                            DrawingCheckmarkView()
                        }
                        .padding()
                    }
                }
                .modifier(VibrateAnimation(animatableData: vibrateOffset))
                .padding(.bottom)
            
            SecureField("비밀번호", text: $password, prompt: Text("비밀번호"))
                .modifier(TextFieldModifier(text: $password, isValidInput: .constant(!loginViewModel.isSignInFail), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .password, focusedTextField: .passwordField, submitLabel: .done))
                .onTapGesture {
                    currentField = .passwordField
                }
                .onSubmit {
                    if email != "" && password != "" {
                        loginViewModel.signIn(email: email, password: password)
                    }
                }
                .onChange(of: password) { newValue in
                    withAnimation(.easeInOut) {
                        loginViewModel.isSignInFail = false
                    }
                }
                .overlay {
                    if loginViewModel.isUserConfirm {
                        HStack {
                            Spacer()
                            
                            DrawingCheckmarkView()
                        }
                        .padding()
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
            
            signInButton()
        }
        .padding()
    }
    
    @ViewBuilder
    func signInButton() -> some View {
        Button {
            loginViewModel.isLoading = true
            currentField = nil
            
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
        .disabled(email == "" || password == "" || loginViewModel.isUserConfirm)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(email != "" && password != "" && !loginViewModel.isLoading && !loginViewModel.isUserConfirm ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func userDeleteButton() -> some View {
        Button {
            tapUserDeleteButton = true
            
            loginViewModel.userDelete()
        } label: {
            HStack {
                Spacer()
                
                if tapUserDeleteButton {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .tint(Color("main-highlight-color"))
                } else {
                    Text("탈퇴하기")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
            }
        }
        .disabled(!loginViewModel.isUserConfirm)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(loginViewModel.isUserConfirm && !tapUserDeleteButton ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    
    @ViewBuilder
    func userDeleteComplete(action: @escaping () -> Void) -> some View {
        VStack(spacing: 10) {
            Spacer()
            
            if showCompleteTitle {
                Text("회원탈퇴 완료!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                    .transition(.move(edge: .bottom))
            }
            
            Spacer()
                .frame(height: 70)
            
            if showCompleteContents {
                VStack {
                    Text("그동안 저희 세종이의집을 이용해주셔서 감사합니다.")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom, 50)
                }
            }
            
            Spacer()
            
            if showCompleteContents {
                Button(action: action) {
                    HStack {
                        Spacer()
                        
                        Text("처음으로 돌아가기")
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
            }
        }
        .padding()
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring()) {
                    showCompleteTitle = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.spring()) {
                    showCompleteContents = true
                }
            }
        }
    }
}

struct UserDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        UserDeleteView(action: {})
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
    }
}
