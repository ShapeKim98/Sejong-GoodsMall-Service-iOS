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
    private var subscriptions = Set<AnyCancellable>()
    private var token: String = ""
    
    @Published var error: APIError?
    @Published var errorView: ErrorView?
    @Published var showLoginView: Bool = true
    @Published var isSignUpComplete: Bool = false
    @Published var isAuthenticate: Bool = false
    @Published var isSignInFail: Bool = false
    @Published var findComplete: Bool = false
    @Published var isLoading: Bool = false
    @Published var message: String?
    @Published var findEmail: String = ""
    @Published var userRequest: UserRequest = UserRequest(email: "", password: "", userName: "", birth: "")
    @Published var findEmailRequest: FindEmailRequest = FindEmailRequest(userName: "", birth: "")
    @Published var memberID: Int?
    
    func signUp() {
        ApiService.fetchSignUp(email: userRequest.email, password: userRequest.password, userName: userRequest.userName, birth: userRequest.birth).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.signUp()
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
    
    func fetchFindEmail() {
        ApiService.fetchFindEmail(userName: findEmailRequest.userName, birth: findEmailRequest.birth).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.fetchFindEmail()
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
