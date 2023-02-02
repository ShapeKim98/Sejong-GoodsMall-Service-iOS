//
//  FindEmailCompleteSheetModifier.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/03.
//

import SwiftUI

struct FindEmailCompleteSheetModifer: ViewModifier {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @Binding var isFindView: Bool
    
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
        } else {
            content
                .fullScreenCover(isPresented: $loginViewModel.findComplete) {
                    findEmailCompleteView()
                }
        }
    }
    
    @ViewBuilder
    func findEmailCompleteView() -> some View {
        HStack {
            Text("이메일 찾기 완료!")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("main-text-color"))
            
            Spacer()
        }
        .padding([.horizontal, .top])
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
        
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
            .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .opacity))
        
        Spacer()
        
        Button {
            loginViewModel.findComplete = false
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
            withAnimation(.easeInOut) {
                loginViewModel.findComplete = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFindView = true
                }
            }
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
