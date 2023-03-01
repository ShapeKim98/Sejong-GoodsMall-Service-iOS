//
//  ErrorView.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/22.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var goodsViewModel: GoodsViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    private let retryAction: () -> Void
    
    init(retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                if !networkManager.isConnected {
                    networkDisconnected()
                } else {
                    if let error = goodsViewModel.error {
                        switch error {
                            case .authenticationFailure:
                                authenticationFailure()
                            case .invalidResponse(statusCode: let statusCode):
                                invalidResponse(statusCode: statusCode)
                            case .cannotNetworkConnect:
                                cannotNetworkConnect()
                            case .urlError(let error):
                                urlError(error: error)
                            case .unknown(_):
                                unknown()
                            default:
                                unknown()
                        }
                    }
                    
                    if let error = loginViewModel.error {
                        switch error {
                            case .authenticationFailure:
                                authenticationFailure()
                            case .invalidResponse(statusCode: let statusCode):
                                invalidResponse(statusCode: statusCode)
                            case .cannotNetworkConnect:
                                cannotNetworkConnect()
                            case .urlError(let error):
                                urlError(error: error)
                            case .unknown(_):
                                unknown()
                            default:
                                unknown()
                        }
                    }
                }
                
                Spacer()
            }
            
            Spacer()
        }
        .background(.white)
    }
    
    @ViewBuilder
    func networkDisconnected() -> some View {
        VStack {
            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(Color("shape-bkg-color"))
                .padding()
            
            Text("인터넷 연결이 오프라인 상태입니다.\n인터넷 연결을 확인하세요.")
                .foregroundColor(Color("secondary-text-color"))
                .padding()
        }
        .frame(maxWidth: 500)
    }
    
    @ViewBuilder
    func authenticationFailure() -> some View {
        VStack {
            Image(systemName: "exclamationmark.lock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(Color("shape-bkg-color"))
                .padding()
            
            Text("로그인이 필요한 기능이에요.\n로그인을 진행해주세요.")
                .foregroundColor(Color("secondary-text-color"))
                .padding()
            
            Button {
                goodsViewModel.error = nil
                goodsViewModel.errorView = nil
                loginViewModel.showLoginView = true
            } label: {
                HStack {
                    Spacer()
                    
                    Text("로그인 하러가기")
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
            .padding()
        }
        .frame(maxWidth: 500)
    }
    
    @ViewBuilder
    func invalidResponse(statusCode: Int) -> some View {
        VStack {
            Image(systemName: "questionmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(Color("shape-bkg-color"))
                .padding()
            
            Text("서버와의 통신중에 오류가 발생했어요 :(\n다시 시도해 주세요.\n오류코드 : \(statusCode)")
                .foregroundColor(Color("secondary-text-color"))
                .padding()
            
            Button(action: retryAction) {
                HStack {
                    Spacer()
                    
                    Text("탭하여 다시 시도")
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
            .padding()
        }
        .frame(maxWidth: 500)
    }
    
    @ViewBuilder
    func cannotNetworkConnect() -> some View {
        VStack {
            Image(systemName: "questionmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(Color("shape-bkg-color"))
                .padding()
            
            
            Text("인터넷 연결이 불안정해요. :(\n연결되어 있는 인터넷이 잘 작동하는지 확인 후,\n다시 시도해 주세요.")
                .foregroundColor(Color("secondary-text-color"))
                .padding()
            
            Button(action: retryAction) {
                HStack {
                    Spacer()
                    
                    Text("탭하여 다시 시도")
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
            .padding()
        }
        .frame(maxWidth: 500)
    }
    
    @ViewBuilder
    func urlError(error: URLError) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(Color("shape-bkg-color"))
                .padding()
            
            Group {
                switch error.code {
                    case .badServerResponse, .cannotConnectToHost, .cannotFindHost:
                        Text("서버와 제대로 통신하지 못했어요. :(\n다시 시도해 주세요.")
                            .foregroundColor(Color("secondary-text-color"))
                    case .backgroundSessionWasDisconnected:
                        Text("서버와의 통신이 알 수 없는 이유로 잠시 중단 되었어요. :(\n다시 시도해 주세요.")
                            .foregroundColor(Color("secondary-text-color"))
                    case .cancelled:
                        Text("서버와의 통신이 알 수 없는 이유로 취소 되었어요. :(\n다시 시도해 주세요.")
                            .foregroundColor(Color("secondary-text-color"))
                    case .networkConnectionLost:
                        Text("서버와의 통신이 알 수 없는 이유로 끊어졌어요. :(\n다시 시도해 주세요.")
                            .foregroundColor(Color("secondary-text-color"))
                    case .timedOut:
                        Text("서버와의 통신이 너무 오래걸려 중단되었어요. :(\n다시 시도해 주세요.")
                            .foregroundColor(Color("secondary-text-color"))
                    default:
                        Text("서버와의 통신중에 알 수 없는 오류가 발생했어요. :(\n다시 시도해 주세요.")
                            .foregroundColor(Color("secondary-text-color"))
                }
            }
            .padding()
            
            Button(action: retryAction) {
                HStack {
                    Spacer()
                    
                    Text("탭하여 다시 시도")
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
            .padding()
        }
        .frame(maxWidth: 500)
    }
    
    @ViewBuilder
    func unknown() -> some View {
        VStack {
            Image(systemName: "questionmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(Color("shape-bkg-color"))
                .padding()
            
            
            Text("알 수 없는 오류가 발생했어요. :(\n다시 시도해 주세요.")
                .foregroundColor(Color("secondary-text-color"))
                .padding()
            
            Button(action: retryAction) {
                HStack {
                    Spacer()
                    
                    Text("탭하여 다시 시도")
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
            .padding()
        }
        .frame(maxWidth: 500)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(retryAction: {})
            .environmentObject(LoginViewModel())
            .environmentObject(GoodsViewModel())
            .environmentObject(NetworkManager())
    }
}
