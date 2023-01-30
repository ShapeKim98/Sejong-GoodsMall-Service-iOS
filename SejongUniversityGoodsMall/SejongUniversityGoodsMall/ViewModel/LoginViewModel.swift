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
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var birth: String = ""
    
    func signUp(email: String, password: String, userName: String, birth: String) {
        ApiService.fetchSignUp(email: email, password: password, userName: userName, birth: birth).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .alreadyEmail:
                            print("이미 존재하는 이메일")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                    print("서버 응답 오류 \(error.errorCode)")
                                    break
                                case .badURL:
                                    print("잘못된 url")
                                    break
                                default:
                                    print("알 수 없는 오류")
                                    break
                            }
                        case .jsonDecodeError:
                            print("데이터 디코딩 에러")
                            break
                        default:
                            print(error.localizedDescription)
                            print("알 수 없는 오류")
                            break
                    }
                case .finished:
                    print("회원가입 성공")
                    break
            }
        } receiveValue: { user in
            print(user)
        }
        .store(in: &subscriptions)
    }
    
    func signIn(email: String, password: String) {
        ApiService.fetchSignIn(email: email, password: password).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            print("로그인 실패")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                    print("서버 응답 오류 \(error.errorCode)")
                                    break
                                case .badURL:
                                    print("잘못된 url")
                                    break
                                default:
                                    print("알 수 없는 오류")
                                    break
                            }
                        case .jsonDecodeError:
                            print("데이터 디코딩 에러")
                            break
                        default:
                            print("알 수 없는 오류")
                            break
                    }
                case .finished:
                    print("로그인 성공")
                    break
            }
        } receiveValue: { loginResponse in
            print(loginResponse)
        }
        .store(in: &subscriptions)
    }
    
    func findEmail(userName: String, birth: String) {
        ApiService.fetchFindEmail(userName: userName, birth: birth).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            print("존재하지 않는 이메일")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                    print("서버 응답 오류 \(error.errorCode)")
                                    break
                                case .badURL:
                                    print("잘못된 url")
                                    break
                                default:
                                    print("알 수 없는 오류")
                                    break
                            }
                        case .jsonDecodeError:
                            print("데이터 디코딩 에러")
                            break
                        default:
                            print("알 수 없는 오류")
                            break
                    }
                case .finished:
                    print("로그인 성공")
                    break
            }
        } receiveValue: { findEmailResponse in
            print(findEmailResponse)
        }
        .store(in: &subscriptions)
    }
}
