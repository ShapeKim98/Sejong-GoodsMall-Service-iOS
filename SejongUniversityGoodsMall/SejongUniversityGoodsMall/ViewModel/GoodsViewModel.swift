//
//  GoodsViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation
import Combine

class GoodsViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var goodsList: GoodsList?
    
    func fetchGoodsList() {
        ApiService.fetchGoodsList().receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                    print("서버 응답 오류")
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
                    print("패치 성공")
                    break
            }
        } receiveValue: { goodsList in
            DispatchQueue.main.async {
                self.goodsList = goodsList
            }
        }
        .store(in: &subscriptions)
    }
}
