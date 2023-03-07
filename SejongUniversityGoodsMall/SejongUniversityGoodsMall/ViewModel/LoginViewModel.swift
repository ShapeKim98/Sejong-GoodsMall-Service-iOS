//
//  LoginViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    enum FindPasswordTextField {
        case inputField
        case verifyCodeField
        case sendVerifyCode
        case changePasswordField
        case delay
    }
    
    enum FindPasswordButton {
        case inputButton
        case verifyCodeButton
        case sendVerifyCodeButton
        case changePasswordButton
    }
    
    private var subscriptions = Set<AnyCancellable>()
    private var token: String = ""
    
    @Published var error: APIError?
    @Published var errorView: ErrorView?
    @Published var showLoginView: Bool = true
    @Published var isSignUpComplete: Bool = false
    @Published var isAuthenticate: Bool = false
    @Published var isSignInFail: Bool = false
    @Published var findComplete: Bool = false
    @Published var updatePasswordComplete: Bool = false
    @Published var isInvalidAuthNumber: Bool = false
    @Published var isLoading: Bool = false
    @Published var message: String?
    @Published var findEmail: String = ""
    @Published var memberID: Int?
    @Published var findPasswordTextField: FindPasswordTextField = .inputField
    @Published var findPasswordButton: FindPasswordButton = .inputButton
    @Published var retrySendVerifyCodeStart: Bool = false
    @Published var retrySendVerifyCodeEnd: Bool = false
    
    func signUp(email: String, password: String, userName: String, birth: String) {
        ApiService.fetchSignUp(email: email, password: password, userName: userName, birth: birth).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.signUp(email: email, password: password, userName: userName, birth: birth)
            }
        } receiveValue: { user in
            DispatchQueue.main.async {
                self.isLoading = false
                
                withAnimation(.easeInOut) {
                    self.isSignUpComplete = true
                }
                print(user)
            }
        }
        .store(in: &subscriptions)
    }
    
    func signIn(email: String, password: String) {
        ApiService.fetchSignIn(email: email, password: password).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.signIn(email: email, password: password)
            }
        } receiveValue: { loginResponse in
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSignInFail = false
                self.token = loginResponse.token
                self.memberID = loginResponse.id
                
                self.isAuthenticate = true
                self.showLoginView = false
            }
            print(loginResponse)
        }
        .store(in: &subscriptions)
    }
    
    func fetchFindEmail(userName: String, birth: String) {
        ApiService.fetchFindEmail(userName: userName, birth: birth).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.fetchFindEmail(userName: userName, birth: birth)
            }
        } receiveValue: { findEmailResponse in
            DispatchQueue.main.async {
                self.findEmail = findEmailResponse.email
                self.isLoading = false
                withAnimation(.spring()) {
                    self.findComplete = true
                }
            }
            print(findEmailResponse)
        }
        .store(in: &subscriptions)
    }
    
    func fetchFindPassword(userName: String, email: String) {
        ApiService.fetchFindPassword(userName: userName, email: email).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.fetchFindPassword(userName: userName, email: email)
            }
        } receiveValue: { data in
            if self.retrySendVerifyCodeStart {
                DispatchQueue.main.async {
                    withAnimation(.easeInOut) {
                        self.retrySendVerifyCodeEnd = true
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    withAnimation(.spring()) {
                        self.findPasswordTextField = .delay
                        self.findPasswordButton = .sendVerifyCodeButton
                        self.isLoading = false
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.spring()) {
                        self.findPasswordTextField = .sendVerifyCode
                    }
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func checkAuthNumber(email: String, inputNum: Int) {
        ApiService.checkAuthNumber(email: email, inputNum: inputNum).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.checkAuthNumber(email: email, inputNum: inputNum)
            }
        } receiveValue: { data in
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.findPasswordTextField = .delay
                    self.findPasswordButton = .changePasswordButton
                    self.isLoading = false
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring()) {
                    self.findPasswordTextField = .changePasswordField
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func updatePassword(email: String, password: String) {
        ApiService.updatePassword(email: email, password: password).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.updatePassword(email: email, password: password)
            }
        } receiveValue: { data in
            DispatchQueue.main.async {
                self.isLoading = false
                self.updatePasswordComplete = true
                self.findPasswordTextField = .inputField
                self.findPasswordButton = .inputButton
            }
        }
        .store(in: &subscriptions)
    }
    
    func completionHandler(completion: Subscribers.Completion<APIError>, retryAction: @escaping () -> Void) {
        switch completion {
            case .failure(let error):
                switch error {
                    case .authenticationFailure:
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                self.isSignInFail = true
                                self.isLoading = false
                            }
                        }
                        print("로그인 실패")
                        break
                    case .isInvalidAuthNumber:
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                self.isInvalidAuthNumber = true
                                self.isLoading = false
                            }
                        }
                    case .isNoneEmail:
                        DispatchQueue.main.async {
                            self.message = "존재하지 않는 이메일"
                            self.isLoading = false
                        }
                        print("존재하지 않는 이메일")
                        break
                    case .alreadyEmail:
                        DispatchQueue.main.async {
                            self.message = "이미 존재하는 이메일"
                            self.isLoading = false
                        }
                        print("이미 존재하는 이메일")
                    case .invalidResponse(statusCode: let statusCode):
                        DispatchQueue.main.async {
                            self.error = .invalidResponse(statusCode: statusCode)
                            self.errorView = ErrorView(retryAction: {
                                self.error = nil
                                self.errorView = nil
                                retryAction()
                            }, closeAction: {
                                self.error = nil
                                self.errorView = nil
                                self.isLoading = false
                            })
                        }
                        break
                    case .cannotNetworkConnect:
                        DispatchQueue.main.async {
                            self.error = .cannotNetworkConnect
                            self.errorView = ErrorView(retryAction: {
                                self.error = nil
                                self.errorView = nil
                                retryAction()
                            }, closeAction: {
                                self.error = nil
                                self.errorView = nil
                                self.isLoading = false
                            })
                        }
                        break
                    case .urlError(let error):
                        DispatchQueue.main.async {
                            self.error = .urlError(error)
                            self.errorView = ErrorView(retryAction: {
                                self.error = nil
                                self.errorView = nil
                                retryAction()
                            }, closeAction: {
                                self.error = nil
                                self.errorView = nil
                                self.isLoading = false
                            })
                        }
                        break
                    case .jsonDecodeError:
                        print("데이터 디코딩 에러")
                        break
                    default:
                        DispatchQueue.main.async {
                            self.message = "알 수 없는 오류"
                        }
                        print("알 수 없는 오류")
                        break
                }
            case .finished:
                print("이메일 찾기 성공")
                break
        }
    }
    
    func returnToken() -> String {
        return self.token
    }
}
