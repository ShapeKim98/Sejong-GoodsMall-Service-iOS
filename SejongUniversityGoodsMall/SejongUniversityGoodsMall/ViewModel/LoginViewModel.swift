//
//  LoginViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isSignUpComplete: Bool = false
    @Published var isAuthenticate: Bool = false
    @Published var isLoading: Bool = false
    @Published var message: String?
    
    func signUp(email: String, password: String, userName: String, birth: String) {
        self.isLoading = true
        
        ApiService.fetchSignUp(email: email, password: password, userName: userName, birth: birth).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .alreadyEmail:
                            DispatchQueue.main.async {
                                self.message = "이미 존재하는 이메일"
                            }
                            print("이미 존재하는 이메일")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                    DispatchQueue.main.async {
                                        self.message = "서버 응답 오류 \(error.errorCode)"
                                    }
                                    print("서버 응답 오류 \(error.errorCode)")
                                    break
                                case .badURL:
                                    DispatchQueue.main.async {
                                        self.message = "잘못된 url"
                                    }
                                    print("잘못된 url")
                                    break
                                default:
                                    DispatchQueue.main.async {
                                        self.message = "알 수 없는 오류"
                                    }
                                    print("알 수 없는 오류")
                                    break
                            }
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.message = "알 수 없는 오류"
                            }
                            print(error.localizedDescription)
                            print("알 수 없는 오류")
                            break
                    }
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                case .finished:
                    DispatchQueue.main.async {
                        self.message = "환영합니다!!\n회원가입이 완료되었습니다!!"
                    }
                    print("회원가입 성공")
                    break
            }
        } receiveValue: { user in
            DispatchQueue.main.async {
                self.isSignUpComplete = true
                self.isLoading = false
            }
            print(user)
        }
        .store(in: &subscriptions)
    }
    
    func signIn(email: String, password: String) {
        self.isLoading = true
        
        ApiService.fetchSignIn(email: email, password: password).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.message = "로그인 실패"
                            }
                            print("로그인 실패")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                    DispatchQueue.main.async {
                                        self.message = "서버 응답 오류 \(error.errorCode)"
                                    }
                                    print("서버 응답 오류 \(error.errorCode)")
                                    break
                                case .badURL:
                                    DispatchQueue.main.async {
                                        self.message = "잘못된 url"
                                    }
                                    print("잘못된 url")
                                    break
                                default:
                                    DispatchQueue.main.async {
                                        self.message = "알 수 없는 오류"
                                    }
                                    print("알 수 없는 오류")
                                    break
                            }
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.message = "알 수 없는 오류"
                            }
                            print(error.localizedDescription)
                            print("알 수 없는 오류")
                            break
                    }
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                case .finished:
                    DispatchQueue.main.async {
                        self.message = "로그인 성공!!"
                    }
                    print("로그인성공")
                    break
            }
        } receiveValue: { loginResponse in
            DispatchQueue.main.async {
                self.isAuthenticate = true
                self.isLoading = false
            }
            print(loginResponse)
        }
        .store(in: &subscriptions)
    }
    
    func findEmail(userName: String, birth: String) {
        self.isLoading = true
        
        ApiService.fetchFindEmail(userName: userName, birth: birth).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.message = "존재하지 않는 이메일"
                            }
                            print("존재하지 않는 이메일")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                    DispatchQueue.main.async {
                                        self.message = "서버 응답 오류 \(error.errorCode)"
                                    }
                                    print("서버 응답 오류 \(error.errorCode)")
                                    break
                                case .badURL:
                                    DispatchQueue.main.async {
                                        self.message = "잘못된 url"
                                    }
                                    print("잘못된 url")
                                    break
                                default:
                                    DispatchQueue.main.async {
                                        self.message = "알 수 없는 오류"
                                    }
                                    print("알 수 없는 오류")
                                    break
                            }
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
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                case .finished:
                    print("이메일 찾기 성공")
                    break
            }
        } receiveValue: { findEmailResponse in
            DispatchQueue.main.async {
                self.message = "이메일 찾기 성공!!\n\(findEmailResponse.email)"
                self.isLoading = false
            }
            print(findEmailResponse)
        }
        .store(in: &subscriptions)
    }
}
