//
//  MessageBoxView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct MessageBoxView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var appViewModel: AppViewModel
    
//    var title: String
//    var secondaryTitle: String
//    var mainButtonTitle: String
//    var secondaryButtonTitle: String
//
//    var mainButtonAction: () -> Void
//    var secondaryButtonAction: () -> Void
//    var closeButtonAction: () -> Void
    
//    init(title: String, secondaryTitle: String, mainButtonTitle: String, secondaryButtonTitle: String, mainButtonAction: @escaping () -> Void, secondaryButtonAction: @escaping () -> Void, closeButtonAction: @escaping () -> Void) {
//        self.title = title
//        self.secondaryTitle = secondaryTitle
//        self.mainButtonTitle = mainButtonTitle
//        self.secondaryButtonTitle = secondaryButtonTitle
//        self.mainButtonAction = mainButtonAction
//        self.secondaryButtonAction = secondaryButtonAction
//        self.closeButtonAction = closeButtonAction
//    }
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                HStack {
                    Text(appViewModel.messageBoxTitle)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("main-text-color"))
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text(appViewModel.messageBoxSecondaryTitle)
                            .font(.subheadline)
                            .foregroundColor(Color("main-text-color"))
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(maxHeight: 60)
                }
                .padding(.top)
                
                Button(action: appViewModel.messageBoxMainButtonAction) {
                    HStack {
                        Spacer()
                        Text(appViewModel.messageBoxMainButtonTitle)
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
                
                Button(action: appViewModel.messageBoxSecondaryButtonAction) {
                    HStack {
                        Spacer()
                        Text(appViewModel.messageBoxSecondaryButtonTitle)
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
                
                Button(action: appViewModel.messageBoxCloseButtonAction) {
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
        .frame(maxWidth: 500)
    }
}

struct MessageBoxView_Previews: PreviewProvider {
    static var previews: some View {
//        MessageBoxView(title: "로그인이 필요한 서비스 입니다", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러 가기", secondaryButtonTitle: "계속 둘러보기") {
//
//        } secondaryButtonAction: {
//
//        } closeButtonAction: {
//
//        }
        MessageBoxView()
        .environmentObject(AppViewModel())
    }
}
