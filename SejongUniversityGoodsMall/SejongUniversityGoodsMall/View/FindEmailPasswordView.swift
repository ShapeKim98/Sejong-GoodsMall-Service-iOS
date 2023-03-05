//
//  FindEmailPasswordView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/31.
//

import SwiftUI

struct FindEmailPasswordView: View {
    enum Page {
        case emailPage
        case passwordPage
    }
    
    @Environment(\.dismiss) var dismiss
    
    @Namespace var heroEffect
    
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    @FocusState private var currentField: FocusedTextField?
    
    @Binding var showDatePicker: Bool
    @Binding var userBirth: String
    
    @State private var findViewTitle: String = "이메일 찾기"
    @State private var page: Page = .emailPage
    @State private var showMessage: Bool = false
    @State private var message: String = ""
    @State private var showFindComplete: Bool = false
    
    init(showDatePicker: Binding<Bool>, userBirth: Binding<String>) {
        self._showDatePicker = showDatePicker
        self._userBirth = userBirth
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    var body: some View {
        VStack {
            if #available(iOS 16.0, *) {
                if !loginViewModel.findComplete {
                    pageSelection()
                    
                    switch page {
                        case .emailPage:
                            findEmailView()
                        case .passwordPage:
                            findPasswordView()
                    }
                } else {
                    findEmailCompleteView()
                }
            } else {
                pageSelection()

                switch page {
                    case .emailPage:
                        findEmailView()
                    case .passwordPage:
                        findPasswordView()
                }
            }
        }
        .background(.white)
        .onTapGesture {
            currentField = nil
        }
        .fullScreenCover(isPresented: $loginViewModel.updatePasswordComplete) {
            updatePasswordComplete()
        }
        .fullScreenCover(isPresented: $loginViewModel.findComplete) {
            findEmailCompleteView()
        }
        .navigationTitle(findViewTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func pageSelection() -> some View {
        VStack {
            HStack {
                pageButton("이메일", .emailPage) {
                    withAnimation(.spring()) {
                        page = .emailPage
                        email = ""
                        userName = ""
                        findViewTitle = "이메일 찾기"
                    }
                }
                
                Spacer()
                
                pageButton("비밀번호", .passwordPage) {
                    withAnimation(.spring()) {
                        page = .passwordPage
                        email = ""
                        userName = ""
                        findViewTitle = "비밀번호 찾기"
                    }
                }
            }
            .padding(.horizontal, 70)
        }
        .background {
            VStack {
                Spacer()
                
                Rectangle()
                    .foregroundColor(Color("shape-bkg-color"))
                    .frame(height: 1)
            }
        }
    }
    
    @ViewBuilder
    func pageButton(_ title: String, _ seleted: Page, _ action: @escaping () -> Void) -> some View {
        let isSelected = page == seleted
        
        Button(action: action) {
            Text(title)
                .font(.system(size: 15))
                .fontWeight(.bold)
                .foregroundColor(isSelected ? Color("main-text-color") : Color("secondary-text-color"))
                .padding(.vertical)
        }
        .overlay(alignment: .bottom) {
            if isSelected {
                Rectangle()
                    .foregroundColor(Color("main-highlight-color"))
                    .frame(height: 3)
                    .matchedGeometryEffect(id: "선택", in: heroEffect)
            }
        }
    }
    
    @ViewBuilder
    func findEmailView() -> some View {
        VStack(spacing: 20) {
            TextField("이름", text: $userName, prompt: Text("이름"))
                .modifier(TextFieldModifier(text: $userName, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .username, focusedTextField: .nameField, submitLabel: .next))
                .onTapGesture {
                    currentField = .emailField
                    showDatePicker = false
                }
                .onSubmit {
                    withAnimation(.spring()) {
                        currentField = nil
                        showDatePicker = true
                    }
                }
            
            Button {
                withAnimation(.spring()) {
                    currentField = nil
                    appViewModel.showMessageBoxBackground = true
                    showDatePicker = true
                }
            } label: {
                HStack {
                    TextField("생년월일", text: $userBirth, prompt: Text("생년월일"))
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
            
            Spacer()
            
            Button {
                loginViewModel.isLoading = true
                loginViewModel.fetchFindEmail(userName: userName, birth: userBirth)
            } label: {
                HStack {
                    Spacer()
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("확인")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .disabled(userName == "" || userBirth == "")
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor((userName != "" && userBirth != "") && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
            }
            .padding(.bottom, 20)
            
            
        }
        .frame(maxWidth: 500)
        .padding(.horizontal)
        .padding(.top, 25)
    }
    
    enum FindPasswordTextField {
        case inputField
        case verifyCodeField
        case changePasswordField
        case delay
    }
    
    enum FindPasswordButton {
        case inputButton
        case verifyCodeButton
        case changePasswordButton
    }
    
    @State private var email: String = ""
    @State private var findPasswordTextField: FindPasswordTextField = .inputField
    @State private var findPasswordButton: FindPasswordButton = .inputButton
    
    @ViewBuilder
    func findPasswordView() -> some View {
        VStack(spacing: findPasswordTextField == .changePasswordField ? nil : 20) {
            switch findPasswordTextField {
                case .inputField:
                    findPasswordInput()
                case .verifyCodeField:
                    verifyCodePage()
                case .changePasswordField:
                    changePasswordPage()
                case .delay:
                    EmptyView()
            }
            
            Spacer()
            
            switch findPasswordButton {
                case .inputButton:
                    findPasswordInputButton()
                case .verifyCodeButton:
                    verifyCodeButton()
                case .changePasswordButton:
                    changePasswordButton()
            }
        }
        .padding(.top, 25)
        
    }
    
    @State private var userName = ""
    
    @ViewBuilder
    func findPasswordInput() -> some View {
        TextField("이름", text: $userName, prompt: Text("이름"))
            .modifier(TextFieldModifier(text: $userName, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .username, focusedTextField: .nameField, submitLabel: .next))
            .onTapGesture {
                currentField = .nameField
                showDatePicker = false
            }
            .onSubmit {
                currentField = .emailField
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            .padding(.horizontal)
        
        TextField("이메일", text: $email, prompt: Text("이메일"))
            .modifier(TextFieldModifier(text: $email, isValidInput: .constant(true), currentField: _currentField, font: .subheadline.bold(), keyboardType: .emailAddress, contentType: .emailAddress, focusedTextField: .emailField, submitLabel: .continue))
            .onTapGesture {
                currentField = .emailField
                showDatePicker = false
            }
            .onSubmit {
                if userName != "" && email != "" {
                    withAnimation(.spring()) {
                        findPasswordButton = .verifyCodeButton
                        findPasswordTextField = .delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring()) {
                                findPasswordTextField = .verifyCodeField
                                currentField = .verifyCodeField
                            }
                        }
                    }
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            .padding(.horizontal)
    }
    
    @ViewBuilder
    func findPasswordInputButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                loginViewModel.isLoading = true
                
                loginViewModel.fetchFindPassword(userName: userName, email: email)
            } label: {
                HStack {
                    Spacer()
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("이메일 발송")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .disabled(userName == "" || email == "")
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor((userName != "" && email != "") && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
            }
            .padding(.bottom, 20)
            .onChange(of: loginViewModel.findPasswordComplete) { newValue in
                if newValue {
                    withAnimation(.spring()) {
                        findPasswordButton = .verifyCodeButton
                        findPasswordTextField = .delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring()) {
                                findPasswordTextField = .verifyCodeField
                                currentField = .verifyCodeField
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    @State private var verifyCode: String = ""
    @State private var isValidVerifyCode: Bool = false
    
    @ViewBuilder
    func verifyCodePage() -> some View {
        TextField("인증코드(6자리)", text: $verifyCode, prompt: Text("인증코드(6자리)"))
            .modifier(TextFieldModifier(text: $verifyCode, isValidInput: $isValidVerifyCode, currentField: _currentField, font: .subheadline.bold(), keyboardType: .numberPad, contentType: .oneTimeCode, focusedTextField: .verifyCodeField, submitLabel: .continue))
            .onTapGesture {
                currentField = .verifyCodeField
            }
            .onSubmit {
                if verifyCode != "" {
                    withAnimation(.spring()) {
                        findPasswordButton = .verifyCodeButton
                        findPasswordTextField = .delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.spring()) {
                                findPasswordTextField = .verifyCodeField
                                currentField = .passwordField
                            }
                        }
                    }
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            .padding(.horizontal)
    }
    
    @ViewBuilder
    func verifyCodeButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                if let inputNum = Int(verifyCode) {
                    loginViewModel.isLoading = true
                    
                    loginViewModel.checkAuthNumber(inputNum: inputNum)
                }
            } label: {
                HStack {
                    Spacer()
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("완료")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .disabled(verifyCode == "")
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(verifyCode != "" && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .onChange(of: loginViewModel.checkAuthNumberComplete) { newValue in
            if newValue {
                withAnimation(.spring()) {
                    findPasswordButton = .changePasswordButton
                    findPasswordTextField = .delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring()) {
                            findPasswordTextField = .changePasswordField
                            currentField = .passwordField
                        }
                    }
                }
            }
        }
    }
    
    @State private var password: String = ""
    @State private var isValidPassword: Bool = false
    @State private var verifyPassword: String = ""
    @State private var isSamePassword: Bool = false
    
    @ViewBuilder
    func changePasswordPage() -> some View {
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
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        .padding(.horizontal)
        
        VStack {
            SecureField("비밀번호 확인", text: $verifyPassword, prompt: Text("비밀번호 확인"))
                .modifier(TextFieldModifier(text: $verifyPassword, isValidInput: $isSamePassword, currentField: _currentField, font: .subheadline.bold(), keyboardType: .default, contentType: .newPassword, focusedTextField: .verifyPasswordField, submitLabel: .next))
                .onTapGesture {
                    currentField = .verifyPasswordField
                    showDatePicker = false
                }
                .onSubmit {
                    
                }
                .onChange(of: verifyPassword) { newValue in
                    isSamePassword = newValue == password ? true : false
                }
                .overlay {
                    if verifyPassword != "" && isSamePassword {
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
        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func changePasswordButton() -> some View {
        VStack {
            Spacer()
            
            Button {
                loginViewModel.isLoading = true
                
                loginViewModel.updatePassword(email: email, password: password)
            } label: {
                HStack {
                    Spacer()
                    if loginViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                            .tint(Color("main-highlight-color"))
                    } else {
                        Text("완료")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .disabled(password == "" || verifyPassword == "" || !isSamePassword)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor((password != "" && verifyPassword != "" && isSamePassword) && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("main-shape-bkg-color"))
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .onChange(of: loginViewModel.updatePasswordComplete) { newValue in
            if newValue {
                
            }
        }
    }
    
    @State private var showCompleteTitle: Bool = false
    @State private var showCompleteContents: Bool = false
    
    @ViewBuilder
    func updatePasswordComplete() -> some View {
        VStack {
            VStack(spacing: 10) {
                Spacer()
                
                if showCompleteTitle {
                    Text("비밀번호 변경 완료!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-text-color"))
                        .transition(.move(edge: .bottom))
                }
                
                Spacer()
                    .frame(height: 70)
                
                if showCompleteContents {
                    VStack {
                        Text("비밀번호 변경이 완료되었습니다.")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("main-text-color"))
                            .padding(.bottom, 50)
                        
                        Text("아래 버튼을 클릭 후,")
                            .foregroundColor(Color("main-text-color"))
                        
                        Text("기존 계정으로 로그인 버튼을 클릭해 주세요.")
                            .foregroundColor(Color("main-text-color"))
                    }
                }
                
                Spacer()
                
                if showCompleteContents {
                    Button {
                        loginViewModel.updatePasswordComplete = false
                        dismiss()
                    } label: {
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
    
    @ViewBuilder
    func findEmailCompleteView() -> some View {
        VStack {
            Spacer()
            
            if showCompleteTitle {
                HStack {
                    Text("이메일 찾기 완료!")
                        .font(showCompleteContents ? .headline : .largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("main-text-color"))
                    
                    if showCompleteContents {
                        Spacer()
                    }
                }
                .padding([.horizontal, .top])
            }
            
            if showCompleteContents {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color("shape-bkg-color"))
                    
                    VStack {
                        Text(loginViewModel.findEmail)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .textSelection(.enabled)
                            .padding()
                        
                        Spacer(minLength: 50)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            if showCompleteContents {
                Button {
                    userName = ""
                    userBirth = ""
                    
                    loginViewModel.findComplete = false
                    
                    dismiss()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("기존 계정으로 로그인")
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
                .padding(.horizontal)
                
                Button {
                    userName = ""
                    userBirth = ""
                    
                    withAnimation(.easeInOut) {
                        page = .passwordPage
                    }
                    
                    loginViewModel.findComplete = false
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("비밀번호 찾기")
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
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
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

struct FindEmailPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        FindEmailPasswordView(showDatePicker: .constant(false), userBirth: .constant("")).updatePasswordComplete()
            .environmentObject(AppViewModel())
            .environmentObject(LoginViewModel())
    }
}
