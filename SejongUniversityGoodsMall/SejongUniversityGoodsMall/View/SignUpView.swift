//
//  SignUpView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/27.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @Binding var showDatePicker: Bool
    
    @State var userBirthday: Date = .now
    
    var body: some View {
        ScrollView {
            registeredUserPage()
            
            termsPage()
            
            signUpButton()
        }
        .onTapGesture {
            currentField = nil
        }
        .overlay {
            if showDatePicker {
                Color(.black).opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showDatePicker = false
                        }
                    }
            }
        }
        .overlay {
            if showDatePicker {
                VStack {
                    Spacer()
                    
                    DatePickerSheetView(userBirthday: $userBirthday, userBirthdayString: $userBirthdayString, showDatePicker: $showDatePicker)
                }
                .ignoresSafeArea()
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    @State private var fullAgreement: Bool = false
    @State private var agreeTermsOfUse: Bool = false
    @State private var agreePersonalInfo: Bool = false
    @State private var agreeMarketingInfo: Bool = false
    
    @ViewBuilder
    func termsPage() -> some View {
        VStack(spacing: 0) {
            Button {
                withAnimation {
                    if !fullAgreement {
                        agreeTermsOfUse = true
                        agreePersonalInfo = true
                        agreeMarketingInfo = true
                    }
                    fullAgreement = true
                }
            } label: {
                HStack {
                    Label("동의", systemImage: "checkmark.circle.fill")
                        .font(.title2)
                        .labelStyle(.iconOnly)
                        .foregroundColor(fullAgreement ? Color("main-highlight-color") : Color("shape-bkg-color"))
                    
                    Text("약관에 전체 동의합니다.")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-text-color"))
                    
                    Spacer()
                }
                .padding()
            }
            
            Rectangle()
                .foregroundColor(Color("shape-bkg-color"))
                .frame(height: 1)
            
            termsLinks(title: "이용약관 (필수)", checked: agreeTermsOfUse) {
                VStack {
                    
                }
            } action: {
                withAnimation {
                    agreeTermsOfUse.toggle()
                    if !agreeTermsOfUse {
                        fullAgreement = false
                    }
                    
                    
                    if agreeTermsOfUse, agreePersonalInfo, agreeMarketingInfo {
                        fullAgreement = true
                    }
                }
            }
            
            termsLinks(title: "개인정보 수집 및 이용 (필수)", checked: agreePersonalInfo) {
                VStack {
                    
                }
            } action: {
                withAnimation {
                    agreePersonalInfo.toggle()
                    if !agreePersonalInfo {
                        fullAgreement = false
                    }
                    
                    
                    if agreeTermsOfUse, agreePersonalInfo, agreeMarketingInfo {
                        fullAgreement = true
                    }
                }
            }
            
            termsLinks(title: "마케팅 정보 수집 (선택)", checked: agreeMarketingInfo) {
                VStack {
                    
                }
            } action: {
                withAnimation {
                    agreeMarketingInfo.toggle()
                    if !agreeMarketingInfo {
                        fullAgreement = false
                    }
                    
                    
                    if agreeTermsOfUse, agreePersonalInfo, agreeMarketingInfo {
                        fullAgreement = true
                    }
                }
            }
            .padding(.bottom)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("shape-bkg-color"))
        }
        .padding()
    }
    
    @ViewBuilder
    func termsLinks(title: String, checked: Bool, destination: () -> some View, action: @escaping () -> Void) -> some View {
        HStack {
            Button(action: action) {
                Label("동의", systemImage: "checkmark.circle.fill")
                    .font(.title2)
                    .labelStyle(.iconOnly)
                    .foregroundColor(checked ? Color("main-highlight-color") : Color("shape-bkg-color"))
            }
            
            NavigationLink(destination: destination) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Label(title, systemImage: "chevron.right")
                        .labelStyle(.iconOnly)
                }
                .foregroundColor(Color("main-text-color"))
            }
        }
        .padding([.horizontal, .top])
    }
    
    @State private var email: String = ""
    @State private var isValidEmail: Bool = false
    @State private var password: String = ""
    @State private var isValidPassword: Bool = false
    @State private var verifyPassword: String = ""
    @State private var isSamePassword: Bool = false
    @State private var userName: String = ""
    @State private var userBirthdayString: String = ""
    
    @FocusState private var currentField: FocusedTextField?
    
    @ViewBuilder
    func registeredUserPage() -> some View {
        VStack {
            HStack {
                Text("이메일 등록")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
            }
            
            VStack {
                TextField("사용하실 이메일을 입력해주세요.", text: $email, prompt: Text("사용하실 이메일을 입력해주세요."))
                    .modifier(TextFieldModifier(text: $email, isValidInput: $isValidEmail, currentField: _currentField, font: .subheadline.bold(), keyboardType: .emailAddress, contentType: .emailAddress, focusedTextField: .emailField, submitLabel: .next))
                    .onTapGesture {
                        currentField = .emailField
                        showDatePicker = false
                    }
                    .onSubmit {
                        currentField = .passwordField
                    }
                    .onChange(of: email) { newValue in
                        if(newValue.range(of:"^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil) {
                            isValidEmail = true
                        } else {
                            isValidEmail = false
                        }
                    }
                    .overlay {
                        if isValidEmail && email != "" {
                            HStack {
                                Spacer()
                                
                                DrawingCheckmarkView()
                            }
                            .padding()
                        }
                    }
                
                HStack {
                    Text(!isValidEmail && email != "" ? "올바르지 않는 이메일 주소입니다." : " ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            VStack {
                SecureField("비밀번호(8자리 이상)", text: $password, prompt: Text("비밀번호(8자리 이상)"))
                    .modifier(TextFieldModifier(text: $password, isValidInput: $isValidPassword, currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .newPassword, focusedTextField: .passwordField, submitLabel: .next))
                    .onTapGesture {
                        currentField = .passwordField
                        showDatePicker = false
                    }
                    .onSubmit {
                        currentField = .verifyPasswordField
                    }
                    .onChange(of: password) { newValue in
                        isValidPassword = newValue.count >= 8 ? true : false
                        if newValue == "" {
                            verifyPassword = ""
                        }
                    }
                    .overlay {
                        if isValidPassword && password != "" && isSamePassword {
                            HStack {
                                Spacer()
                                
                                DrawingCheckmarkView()
                            }
                            .padding()
                        }
                    }
                
                HStack {
                    Text(!isValidPassword && password != "" ? "비밀번호는 8자리 이상으로 설정할 수 있습니다." : " ")
                        .font(.caption)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            VStack {
                SecureField("비밀번호 확인", text: $verifyPassword, prompt: Text("비밀번호 확인"))
                    .modifier(TextFieldModifier(text: $verifyPassword, isValidInput: $isSamePassword, currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .newPassword, focusedTextField: .verifyPasswordField, submitLabel: .next))
                    .onTapGesture {
                        currentField = .verifyPasswordField
                        showDatePicker = false
                    }
                    .onSubmit {
                        currentField = .nameField
                    }
                    .onChange(of: verifyPassword) { newValue in
                        isSamePassword = newValue == password ? true : false
                    }
                    .overlay {
                        if isValidEmail && verifyPassword != "" && isSamePassword {
                            HStack {
                                Spacer()
                                
                                DrawingCheckmarkView()
                            }
                            .padding()
                        }
                    }
                
                HStack {
                    Text(!isSamePassword && verifyPassword != "" ? "비밀번호가 일치하지 않습니다." : " ")
                        .font(.caption2)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            HStack {
                Text("프로필 정보")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
            }
            .padding(.top)
            
            VStack {
                TextField("이름", text: $userName, prompt: Text("이름"))
                    .modifier(TextFieldModifier(text: $userName, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .username, focusedTextField: .nameField, submitLabel: .next))
                    .onTapGesture {
                        currentField = .nameField
                        showDatePicker = false
                    }
                    .onSubmit {
                        withAnimation(.spring()) {
                            currentField = nil
                            showDatePicker = true
                        }
                    }
                
                HStack {
                    Text(" ")
                        .font(.caption2)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Button {
                withAnimation(.spring()) {
                    currentField = nil
                    showDatePicker = true
                }
            } label: {
                HStack {
                    TextField("생년월일", text: $userBirthdayString, prompt: Text("생년월일"))
                        .font(.subheadline.bold())
                    
                    Spacer()
                }
                .disabled(true)
                .multilineTextAlignment(.leading)
                .padding(10)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("shape-bkg-color"))
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func signUpButton() -> some View {
        Button {
            loginViewModel.signUp(email: email, password: password, userName: userName, birth: userBirthdayString)
        } label: {
            HStack {
                Spacer()
                
                if loginViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .tint(Color("main-highlight-color"))
                } else {
                    Text("회원가입 완료")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                }
                
                Spacer()
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor((agreeTermsOfUse && agreePersonalInfo && isValidEmail && isSamePassword && email != "" && password != "" && verifyPassword != "" && userName != "" && userBirthdayString != "") && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("shape-bkg-color"))
        }
        .disabled((!(agreeTermsOfUse && agreePersonalInfo && isValidEmail && isSamePassword && email != "" && password != "" && verifyPassword != "" && userName != "" && userBirthdayString != "")) || loginViewModel.isLoading)
        .padding()
        .padding(.bottom, 20)
    }
    
    
    @ViewBuilder
    func textFieldBackground(isValidInput: Bool, input: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(isValidInput || input == "" ? Color("shape-bkg-color") : Color("main-highlight-color"))
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                SignUpView(showDatePicker: .constant(false))
                    .environmentObject(LoginViewModel())
            }
        } else {
            NavigationView {
                SignUpView(showDatePicker: .constant(false))
                    .environmentObject(LoginViewModel())
            }
        }
    }
}
