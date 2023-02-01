//
//  FindEmailPasswordView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/31.
//

import SwiftUI

enum Page {
    case emailPage
    case passwordPage
}

struct FindEmailPasswordView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    @State var page: Page = .emailPage
    @State var showDatePicker: Bool = false
    @State var showMessage: Bool = false
    @State var message: String = ""
    
    init() {
        if #available(iOS 16.0, *) {

        } else {
            SetNavigationBarColor.navigationBarColors(background: .white, titleColor: UIColor(Color("main-text-color")))
        }
        
        self.dateFormatter.locale = Locale(identifier: "ko_kr")
        self.dateFormatter.dateFormat = "yyyy/MM/dd"
    }
    
    var body: some View {
        VStack {
            pageSelection()
            
            switch page {
                case .emailPage:
                    findEmailView()
                case .passwordPage:
                    findPasswordView()
            }
        }
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
    
    @ViewBuilder
    func pageSelection() -> some View {
        VStack {
            HStack {
                pageButton("이메일", .emailPage) {
                    withAnimation {
                        page = .emailPage
                    }
                }
                
                Spacer()
                
                pageButton("비밀번호", .passwordPage) {
                    withAnimation {
                        page = .passwordPage
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
        .background {
            VStack {
                Spacer()
                
                Rectangle()
                    .foregroundColor(isSelected ? Color("main-highlight-color") : .clear)
                    .frame(height: 3)
            }
        }
    }
    
    @State private var userName: String = ""
    @State private var userBirthdayString: String = ""
    @State private var userBirthday: Date = .now
    @ViewBuilder
    func findEmailView() -> some View {
        VStack(spacing: 20) {
            TextField("이름", text: $userName, prompt: Text("이름"))
                .font(.subheadline.bold())
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textContentType(.name)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("shape-bkg-color"))
                }
            
            Button {
                withAnimation(.spring()) {
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
                .padding()
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("shape-bkg-color"))
            }
            
            Spacer()
            
            Button {
                loginViewModel.findEmail(userName: userName, birth: userBirthdayString)
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
            .disabled((userName == "" || userBirthdayString == "") || loginViewModel.isLoading)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor((userName != "" && userBirthdayString != "") && !loginViewModel.isLoading ? Color("main-highlight-color") : Color("shape-bkg-color"))
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .padding(.top, 25)
    }
    
    @ViewBuilder
    func findPasswordView() -> some View {
        
    }
}

struct FindEmailPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        FindEmailPasswordView()
            .environmentObject(LoginViewModel())
    }
}
