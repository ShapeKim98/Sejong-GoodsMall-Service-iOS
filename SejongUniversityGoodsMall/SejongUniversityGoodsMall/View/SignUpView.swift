//
//  SignUpView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/27.
//

import SwiftUI

struct SignUpView: View {
    init() {
        if #available(iOS 16.0, *) {

        } else {
            Self.navigationBarColors(background: .white, titleColor: UIColor(Color("main-text-color")))
        }
        
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.dateFormat = "yy/MM/dd"
    }
    
    var body: some View {
        VStack {
            termsPage()
        }
        .navigationTitle("")
    }
    
    @State private var fullAgreement: Bool = false
    @State private var agreeTermsOfUse: Bool = false
    @State private var agreePersonalInfo: Bool = false
    @State private var agreeMarketingInfo: Bool = false
    
    @ViewBuilder
    func termsPage() -> some View {
        VStack {
            HStack {
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
                    Label("동의", systemImage: "checkmark.circle.fill")
                        .font(.title2)
                        .labelStyle(.iconOnly)
                        .foregroundColor(fullAgreement ? Color("main-highlight-color") : Color("shape-bkg-color"))
                }
                
                Text("약관에 전체 동의합니다.")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
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
            
            Spacer()
            
            NavigationLink {
                registeredUserPage()
            } label: {
                HStack {
                    Spacer()
                    
                    Text("동의하고 가입하기")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(agreeTermsOfUse && agreePersonalInfo ? Color("main-highlight-color") : Color("shape-bkg-color"))
            }
            .disabled(!agreeTermsOfUse && !agreePersonalInfo)
            .padding(.bottom, 50)
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
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Label(title, systemImage: "chevron.right")
                        .labelStyle(.iconOnly)
                }
                .foregroundColor(Color("main-text-color"))
            }
        }
        .padding(.top)
    }
    
    @State private var email: String = ""
    @State private var isValidEmail: Bool = false
    @State private var password: String = ""
    @State private var isValidPassword: Bool = false
    @State private var verifyPassword: String = ""
    @State private var isSamePassword: Bool = false
    @State private var userName: String = ""
    @State private var userBirthdayString: String = ""
    @State private var userBirthday: Date = .now
    @State private var showDatePicker: Bool = false
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    @ViewBuilder
    func registeredUserPage() -> some View {
        VStack {
            HStack {
                Text("계정 등록")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
            }
            .padding(.bottom)
            
            VStack {
                TextField("사용하실 이메일을 입력해주세요.", text: $email, prompt: Text("사용하실 이메일을 입력해주세요."))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding()
                    .background {
                        textFieldBackground(isValidInput: isValidEmail, input: email)
                    }
                    .onChange(of: email) { newValue in
                        if(newValue.range(of:"^\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$", options: .regularExpression) != nil) {
                            isValidEmail = true
                        } else {
                            isValidEmail = false
                        }
                    }
                
                HStack {
                    Text(!isValidEmail && email != "" ? "올바르지 않는 이메일 주소입니다." : " ")
                        .font(.caption)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            VStack {
                SecureField("비밀번호(8자리 이상)", text: $password, prompt: Text("비밀번호(8자리 이상)"))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.newPassword)
                    .padding()
                    .background {
                        textFieldBackground(isValidInput: isValidPassword, input: password)
                    }
                    .onChange(of: password) { newValue in
                        isValidPassword = newValue.count >= 8 ? true : false
                        if newValue == "" {
                            verifyPassword = ""
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
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.newPassword)
                    .padding()
                    .background {
                        textFieldBackground(isValidInput: isSamePassword, input: verifyPassword)
                    }
                    .onChange(of: verifyPassword) { newValue in
                        isSamePassword = newValue == password ? true : false
                    }
                
                HStack {
                    Text(!isSamePassword && verifyPassword != "" ? "비밀번호가 일치하지 않습니다." : " ")
                        .font(.caption)
                        .foregroundColor(Color("main-highlight-color"))
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            HStack {
                Text("프로필 정보")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color("main-text-color"))
                
                Spacer()
            }
            .padding(.vertical)
            
            VStack {
                TextField("이름", text: $userName, prompt: Text("이름"))
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(.name)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("shape-bkg-color"))
                    }
                
                HStack {
                    Text(" ")
                        .font(.caption)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Button {
                showDatePicker = true
            } label: {
                HStack {
                    TextField("생년월일", text: $userBirthdayString, prompt: Text("생년월일"))
                    
                    Spacer()
                }
                .disabled(true)
                .multilineTextAlignment(.leading)
                .padding()
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("shape-bkg-color"))
            }
            .sheet(isPresented: $showDatePicker) {
                if #available(iOS 16.0, *) {
                    VStack {
                        HStack {
                            Button("취소", role: .cancel) {
                                showDatePicker = false
                            }
                            
                            Spacer()
                            
                            Button("완료") {
                                userBirthdayString = dateFormatter.string(from: userBirthday)
                                showDatePicker = false
                            }
                        }
                        
                        DatePicker(selection: $userBirthday, in: ...Date.now, displayedComponents: .date) {
                            
                        }
                        .datePickerStyle(.graphical)
                    }
                    .padding()
                    .presentationDetents([.medium, .large])
                } else {
                    HalfSheet {
                        VStack {
                            HStack {
                                Button("취소", role: .cancel) {
                                    showDatePicker = false
                                }
                                
                                Spacer()
                                
                                Button("완료") {
                                    userBirthdayString = dateFormatter.string(from: userBirthday)
                                    showDatePicker = false
                                }
                            }
                            
                            DatePicker(selection: $userBirthday, in: ...Date.now, displayedComponents: .date) {
                                
                            }
                            .datePickerStyle(.graphical)
                        }
                        .padding()
                        .datePickerStyle(.wheel)
                    }
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                HStack {
                    Spacer()
                    
                    Text("회원가입 완료")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(isValidEmail && isSamePassword && isSamePassword && email != "" && password != "" && verifyPassword != "" && userName != "" && userBirthdayString != "" ? Color("main-highlight-color") : Color("shape-bkg-color"))
            }
            .disabled(!(isValidEmail && isSamePassword && isSamePassword && email != "" && password != "" && verifyPassword != "" && userName != "" && userBirthdayString != ""))
            .padding(.bottom, 50)
        }
        .padding()
    }
    
    @ViewBuilder
    func textFieldBackground(isValidInput: Bool, input: String) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(isValidInput || input == "" ? Color("shape-bkg-color") : Color("main-highlight-color"))
    }
    
    static func navigationBarColors(background : UIColor?, titleColor : UIColor? = nil, tintColor : UIColor? = nil ){
        
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = background ?? .clear
        
        navigationAppearance.titleTextAttributes = [.foregroundColor: titleColor ?? .black]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: titleColor ?? .black]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        
        UINavigationBar.appearance().tintColor = tintColor ?? titleColor ?? .black
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                SignUpView().registeredUserPage()
            }
        } else {
            NavigationView {
                SignUpView()
            }
        }
    }
}
