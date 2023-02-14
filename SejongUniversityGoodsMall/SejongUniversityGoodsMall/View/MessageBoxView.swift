//
//  MessageBoxView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct MessageBoxView: View {
    @Binding var showMessageBox: Bool
    
    @State private var title: String
    @State private var secondaryTitle: String
    @State private var mainButtonTitle: String
    @State private var secondaryButtonTitle: String
    
    private let mainButtonAction: () -> Void
    private let secondaryButtonAction: () -> Void
    
    init(showMessageBox: Binding<Bool>, title: String, secondaryTitle: String, mainButtonTitle: String, secondaryButtonTitle: String, mainButtonAction: @escaping () -> Void, secondaryButtonAction: @escaping () -> Void) {
        self._showMessageBox = showMessageBox
        self.title = title
        self.secondaryTitle = secondaryTitle
        self.mainButtonTitle = mainButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
        self.mainButtonAction = mainButtonAction
        self.secondaryButtonAction = secondaryButtonAction
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("main-text-color"))
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text(secondaryTitle)
                            .font(.subheadline)
                            .foregroundColor(Color("main-text-color"))
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(maxHeight: 60)
                }
                .padding(.top)
                
                Button(action: mainButtonAction) {
                    HStack {
                        Spacer()
                        Text(mainButtonTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                        
                        Spacer()
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("main-highlight-color"))
                }
                .padding(.top)
                
                Button(action: secondaryButtonAction) {
                    HStack {
                        Spacer()
                        Text(secondaryButtonTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("main-text-color"))
                            .padding()
                        
                        Spacer()
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("main-shape-bkg-color"))
                }
                .padding(.bottom)
                
                Button {
                    withAnimation(.spring()) {
                        showMessageBox = false
                    }
                } label: {
                    Text("닫기")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("secondary-text-color"))
                }
                
            }
            .padding(.horizontal)
            .padding(.vertical, 25)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("shape-bkg-color"))
            }
            .padding()
            
            Spacer()
        }
    }
}

struct MessageBoxView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBoxView(showMessageBox: .constant(true), title: "로그인이 필요한 서비스 입니다", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러 가기", secondaryButtonTitle: "계속 둘러보기") {
            
        } secondaryButtonAction: {
            
        }

    }
}
