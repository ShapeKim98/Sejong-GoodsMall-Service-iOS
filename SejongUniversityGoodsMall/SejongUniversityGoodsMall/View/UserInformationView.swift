//
//  UserInformationView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/14.
//

import SwiftUI

struct UserInformationView: View {
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
                    .padding()
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
                    .padding(.vertical)
                
                Spacer()
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("내 정보 변경")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("주문 내역")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("로그아웃")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("회원탈퇴")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
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
                Text("계정")
                    .font(.headline)
                    .foregroundColor(Color("main-text-color"))
                    .padding(.vertical)
                
                Spacer()
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("내 정보 변경")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("주문 내역")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("로그아웃")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
                    Spacer()
                }
            }
            
            NavigationLink {
                
            } label: {
                HStack {
                    Text("회원탈퇴")
                        .foregroundColor(Color("main-text-color"))
                        .padding(.bottom)
                    
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
