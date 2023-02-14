//
//  UserInformationView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct UserInformationView: View {
    @State private var showMessageBox: Bool = false
    
    var body: some View {
        VStack {
            wishListButton()
                .padding()
            
            accountManageArea()
                .padding([.horizontal, .bottom])
            
            helpArea()
                .padding(.horizontal)
            
            Spacer()
        }
        .background(.white)
        .overlay {
            if showMessageBox {
                MessageBoxView(showMessageBox: $showMessageBox, title: "로그인이 필요한 서비스 입니다", secondaryTitle: "로그인 하시겠습니까?", mainButtonTitle: "로그인 하러 가기", secondaryButtonTitle: "계속 둘러보기") {
                    
                } secondaryButtonAction: {
                    
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
    
    @ViewBuilder
    func wishListButton() -> some View {
        HStack {
            NavigationLink {
                WishListView()
                    .navigationTitle("찜한 상품")
                    .navigationBarTitleDisplayMode(.inline)
                    .modifier(NavigationColorModifier())
            } label: {
                Text("💖 찜한 상품 보러가기")
                    .foregroundColor(Color("main-text-color"))
                    .padding(.horizontal)
                    .padding(.vertical, 25)
            }
            
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("main-text-color"), lineWidth: 0.25)
                .shadow(radius: 5, x: -5, y: 5)
        }
    }
    
    @ViewBuilder
    func accountManageArea() -> some View {
        VStack {
            HStack {
                Text("계정")
                    .font(.headline)
                    .padding(.top, 25)
                
                Spacer()
            }
            
            Button {
                withAnimation(.spring()) {
                    showMessageBox = true
                }
            } label: {
                HStack {
                    Text("내 정보 변경")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("주문 내역")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("로그아웃")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("회원탈퇴")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                        .padding(.bottom, 25)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("main-text-color"), lineWidth: 0.25)
        }
    }
    
    @ViewBuilder
    func helpArea() -> some View {
        VStack {
            HStack {
                Text("도움말")
                    .font(.headline)
                    .padding(.top, 25)
                
                Spacer()
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("공지사항")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("고객센터")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("개인정보 처리 방침")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("이용약관 확인")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.top)
                        .padding(.bottom, 25)
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("main-text-color"), lineWidth: 0.25)
        }
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                UserInformationView()
            }
        } else {
            NavigationView {
                UserInformationView()
            }
        }
    }
}
