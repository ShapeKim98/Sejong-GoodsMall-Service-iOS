//
//  LoginView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/27.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State var userBirth: String = ""
    @State var showDatePicker: Bool = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 350, maximum: .infinity), spacing: nil, alignment: .top)
    ]
    
    init() {
        if #available(iOS 16.0, *) {

        } else {
            SetNavigationBarColor.navigationBarColors(background: .white, titleColor: UIColor(Color("main-text-color")))
        }
    }
    
    var body: some View {
        GeometryReader { reader in
            if #available(iOS 16.0, *) {
                NavigationStack {
                    VStack {
                        title()
                        
                        Spacer()
                        
                        buttons()
                            .frame(maxWidth: 500)
                    }
                    .navigationTitle("")
                    .navigationBarBackButtonHidden()
                }
                .tint(Color("main-text-color"))
                .overlay(alignment: .bottom) {
                    datePicker()
                }
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
                .overlay(alignment: .bottom) {
                    datePicker()
                }
            }
        }
    }
    
    @ViewBuilder
    func title() -> some View {
        VStack {
            Spacer()
            
            Image("icon")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("세종이의 집")
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
                SignUpView(showDatePicker: $showDatePicker, userBirth: $userBirth)
                    .navigationTitle("이메일로 가입하기")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
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
            .padding(.bottom)
            
            NavigationLink {
                SignInView(showDatePicker: $showDatePicker, userBirth: $userBirth)
                    .navigationTitle("기존 계정으로 로그인")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
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
            .padding(.bottom)
            
            Button {
                loginViewModel.showLoginView = false
            } label: {
                Text("건너뛰기")
                    .fontWeight(.semibold)
                    .background(alignment: .bottom) {
                        Rectangle()
                            .frame(height: 0.5)
                    }
                    .foregroundColor(Color("secondary-text-color"))
            }
        }
        .padding()
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func datePicker() -> some View {
        ZStack(alignment: .bottom) {
            if appViewModel.showMessageBoxBackground {
                Color(.black).opacity(0.4)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showDatePicker = false
                        }
                        
                        withAnimation(.easeOut) {
                            appViewModel.showMessageBoxBackground = false
                        }
                    }
            }
            
            if showDatePicker {
                DatePickerSheetView(userBirthdayString: $userBirth, showDatePicker: $showDatePicker)
                    .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AppViewModel())
            .environmentObject(LoginViewModel())
    }
}
