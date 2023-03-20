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
    private let tokenAccessKey = UIDevice.current.identifierForVendor!.uuidString
    
    let hapticFeedback = UINotificationFeedbackGenerator()
    
    @AppStorage("AUTHENTICATE") var isAuthenticate: Bool = false
    @AppStorage("SHOWLOGINVIEW") var showLoginView: Bool = true
    
    @Published var error: APIError?
    @Published var errorView: ErrorView?
    @Published var isAlreadyEmail: Bool = false
    @Published var isSignUpComplete: Bool = false
    @Published var isSignInFail: Bool = false
    @Published var isNoneEmail: Bool = false
    @Published var isNoneUser: Bool = false
    @Published var findComplete: Bool = false
    @Published var updatePasswordComplete: Bool = false
    @Published var isInvalidAuthNumber: Bool = false
    @Published var isLoading: Bool = false
    @Published var message: String?
    @Published var findEmail: String = ""
    @Published var findPasswordTextField: FindPasswordTextField = .inputField
    @Published var findPasswordButton: FindPasswordButton = .inputButton
    @Published var retrySendVerifyCodeStart: Bool = false
    @Published var retrySendVerifyCodeEnd: Bool = false
    @Published var isUserConfirm: Bool = false
    @Published var isUserDeleteComplete: Bool = false
    
    init() {
        if let token = self.loadTokenFromKeychain() {
            self.token = token
        } else {
            self.isAuthenticate = false
            self.showLoginView = true
        }
    }
    
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
                self.saveTokenToKeychain(token: loginResponse.token)
                self.isAuthenticate = true
                self.showLoginView = false
                
                withAnimation(.easeInOut) {
                    self.isUserConfirm = true
                }
            }
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
    
    func userDelete() {
        APIService.userDelete(token: self.token).subscribe(on: DispatchQueue.global(qos: .background)).retry(1).sink { completion in
            self.completionHandler(completion: completion) {
                self.userDelete()
            }
        } receiveValue: { data in
            DispatchQueue.main.async {
                self.isLoading = false
                
                withAnimation(.spring()) {
                    self.isUserDeleteComplete = true
                }
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
                                self.isAuthenticate = false
                                self.isLoading = false
                            }
                            
                            self.hapticFeedback.notificationOccurred(.error)
                        }
                    case .isInvalidAuthNumber:
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                self.isInvalidAuthNumber = true
                                self.isLoading = false
                            }
                        }
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
                            
                            self.hapticFeedback.notificationOccurred(.error)
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
                            
                            self.hapticFeedback.notificationOccurred(.error)
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
                            
                            self.hapticFeedback.notificationOccurred(.error)
                        }
                    case .jsonDecodeError:
                        DispatchQueue.main.async {
                            self.hapticFeedback.notificationOccurred(.error)
                        }
                    default:
                        DispatchQueue.main.async {
                            self.error = error
                            self.errorView = ErrorView(retryAction: {
                                self.error = nil
                                self.errorView = nil
                                retryAction()
                            }, closeAction: {
                                self.error = nil
                                self.errorView = nil
                            })
                            
                            self.hapticFeedback.notificationOccurred(.error)
                        }
                }
                break
            case .finished:
                DispatchQueue.main.async {
                    self.hapticFeedback.notificationOccurred(.success)
                }
                break
        }
    }
    
    func returnToken() -> String {
        return self.token
    }
    
    func saveTokenToKeychain(token: String) {
        guard let data = token.data(using: String.Encoding.utf8) else {
            return
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenAccessKey,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            self.deleteTokenFromKeychain()
            self.saveTokenToKeychain(token: token)
            
            return
        }
    }
    
    func deleteTokenFromKeychain() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenAccessKey
        ]
        
        SecItemDelete(query as CFDictionary)
    }
    
    func loadTokenFromKeychain() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenAccessKey,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else {
            return nil
        }
        
        guard let retrievedData = dataTypeRef as? Data else {
            return nil
        }
        
        let result = String(data: retrievedData, encoding: .utf8)
        
        return result
    }
    
    func reset() {
        error = nil
        errorView = nil
        isAlreadyEmail = false
        isSignUpComplete = false
        isSignInFail = false
        isNoneEmail = false
        isNoneUser = false
        findComplete = false
        updatePasswordComplete = false
        isInvalidAuthNumber = false
        isLoading = false
        message = nil
        findEmail = ""
        findPasswordTextField = .inputField
        findPasswordButton = .inputButton
        retrySendVerifyCodeStart = false
        retrySendVerifyCodeEnd = false
        token = ""
        deleteTokenFromKeychain()
        isUserConfirm = false
        isUserDeleteComplete = false
    }
}
