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
                
                Button(action: appViewModel.messageBoxCloseButtonAction) {
                    HStack {
                        Spacer()
                        
                        Text("닫기")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        .foregroundColor(Color("secondary-text-color"))
                        .padding()
                        
                        Spacer()
                    }
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
        MessageBoxView()
        .environmentObject(AppViewModel())
    }
}
