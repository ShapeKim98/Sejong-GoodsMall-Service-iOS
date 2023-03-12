//
//  LoginViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation
import SwiftUI
import Combine
import Security

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
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    @Published var error: APIError?
    @Published var errorView: ErrorView?
    @Published var showLoginView: Bool = true
    @Published var isAlreadyEmail: Bool = false
    @Published var isSignUpComplete: Bool = false
    @Published var isAuthenticate: Bool = false
    @Published var isSignInFail: Bool = false
    @Published var isNoneEmail: Bool = false
    @Published var isNoneUser: Bool = false
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
        APIService.fetchSignUp(email: email, password: password, userName: userName, birth: birth).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
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
        APIService.fetchSignIn(email: email, password: password).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.signIn(email: email, password: password)
            }
        } receiveValue: { loginResponse in
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSignInFail = false
                self.token = loginResponse.token
                self.memberID = loginResponse.id
                self.saveToKeychain(email: email, password: password)
                self.isAuthenticate = true
                self.showLoginView = false
            }
            print(loginResponse)
        }
        .store(in: &subscriptions)
    }
    
    func fetchFindEmail(userName: String, birth: String) {
        APIService.fetchFindEmail(userName: userName, birth: birth).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
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
        APIService.fetchFindPassword(userName: userName, email: email).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
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
        APIService.checkAuthNumber(email: email, inputNum: inputNum).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
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
        APIService.updatePassword(email: email, password: password).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
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
                            
                            self.hapticFeedback.notificationOccurred(.error)
                        }
                        print("로그인 실패")
                    case .isInvalidAuthNumber:
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                self.isInvalidAuthNumber = true
                                self.isLoading = false
                            }
                        }
                    case .isNoneEmail:
                        DispatchQueue.main.async {
                            self.isNoneEmail = true
                            self.isLoading = false
                            self.hapticFeedback.notificationOccurred(.error)
                        }
                        print("존재하지 않는 이메일")
                    case .isNoneUser:
                        DispatchQueue.main.async {
                            self.isNoneUser = true
                            self.isLoading = false
                            self.hapticFeedback.notificationOccurred(.error)
                        }
                    case .alreadyEmail:
                        DispatchQueue.main.async {
                            self.isAlreadyEmail = true
                            self.isLoading = false
                            self.hapticFeedback.notificationOccurred(.error)
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
                            self.hapticFeedback.notificationOccurred(.warning)
                        }
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
                            self.hapticFeedback.notificationOccurred(.warning)
                        }
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
                            self.hapticFeedback.notificationOccurred(.warning)
                        }
                    case .jsonDecodeError:
                        print("데이터 디코딩 에러")
                        DispatchQueue.main.async {
                            self.hapticFeedback.notificationOccurred(.warning)
                        }
                    default:
                        DispatchQueue.main.async {
                            self.message = "알 수 없는 오류"
                            self.hapticFeedback.notificationOccurred(.warning)
                        }
                        print("알 수 없는 오류")
                }
                break
            case .finished:
                DispatchQueue.main.async {
                    self.hapticFeedback.notificationOccurred(.success)
                }
                print("이메일 찾기 성공")
                break
        }
    }
    
    func returnToken() -> String {
        return self.token
    }
    
    private func saveToKeychain(email: String, password: String) {
        guard let info = Bundle.main.infoDictionary, let bundleID = info["CFBundleIdentifier"] as? String else {
            return
        }
        
        let account = email
        let passwordData = Data(password.utf8)
        let service = bundleID // Keychain 항목의 이름
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecValueData as String: passwordData,
            kSecAttrService as String: service,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecAttrSynchronizable as String: true
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Saved to Keychain")
        } else {
            print("Error saving to Keychain")
        }
    }
}
