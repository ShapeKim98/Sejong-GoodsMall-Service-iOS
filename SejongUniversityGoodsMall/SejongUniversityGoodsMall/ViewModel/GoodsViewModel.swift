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
    
    @Published var goodsList: GoodsList = [Goods(id: 0, categoryID: 0, title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading..."),
                                           Goods(id: 1, categoryID: 0, title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading..."),
                                           Goods(id: 2, categoryID: 0, title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading..."),
                                           Goods(id: 3, categoryID: 0, title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading...")
    ]
    @Published var goodsDetail: Goods = Goods(id: 0, categoryID: nil, title: "loading...", color: nil, size: nil, price: 99999, goodsImages: [], goodsInfos: [], description: "loading...")
    @Published var isLoading: Bool = true
    @Published var message: String?
    @Published var cart: Cart = Cart()
    
    func fetchGoodsList() {
        self.isLoading = true
        ApiService.fetchGoodsList().receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.message = "접근 권한 없음"
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                        DispatchQueue.main.async {
                                            self.message = "서버 응답 오류 \(error.errorCode)"
                                        }
                                    print("서버 응답 오류")
                                    break
                                case .badURL:
                                    DispatchQueue.main.async {
                                        self.message = "잘못된 url"
                                    }
                                    print("잘못된 url")
                                    break
                                default:
                                    DispatchQueue.main.async {
                                        self.message = "알 수 없는 오류 \(error.errorCode)"
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
                                self.message = "알 수 없는 오류 \(error)"
                            }
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
                self.isLoading = false
            }
        }
        .store(in: &subscriptions)
    }
    
    func fetchGoodsListFromCatefory(id: Int) {
        self.isLoading = true
        ApiService.fetchGoodsListFromCategory(id: id).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.message = "접근 권한 없음"
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                        DispatchQueue.main.async {
                                            self.message = "서버 응답 오류 \(error.errorCode)"
                                        }
                                    print("서버 응답 오류")
                                    break
                                case .badURL:
                                    DispatchQueue.main.async {
                                        self.message = "잘못된 url"
                                    }
                                    print("잘못된 url")
                                    break
                                default:
                                    DispatchQueue.main.async {
                                        self.message = "알 수 없는 오류 \(error.errorCode)"
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
                                self.message = "알 수 없는 오류 \(error)"
                            }
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
                self.isLoading = false
            }
        }
        .store(in: &subscriptions)
    }
    
    func fetchGoodsDetail(id: Int) {
        self.isLoading = true
        ApiService.fetchGoodsDetail(id: id).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.message = "접근 권한 없음"
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(let error):
                            switch error.code {
                                case .badServerResponse:
                                        DispatchQueue.main.async {
                                            self.message = "서버 응답 오류 \(error.errorCode)"
                                        }
                                    print("서버 응답 오류")
                                    break
                                case .badURL:
                                    DispatchQueue.main.async {
                                        self.message = "잘못된 url"
                                    }
                                    print("잘못된 url")
                                    break
                                default:
                                    DispatchQueue.main.async {
                                        self.message = "알 수 없는 오류 \(error.errorCode)"
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
                                self.message = "알 수 없는 오류 \(error)"
                            }
                            print("알 수 없는 오류")
                            break
                    }
                case .finished:
                    print("패치 성공")
                    break
            }
        } receiveValue: { goodsDetail in
            DispatchQueue.main.async {
                self.goodsDetail = goodsDetail
                self.isLoading = false
            }
        }
        .store(in: &subscriptions)
    }
    
    func addingCart(memberID: Int, seletedColor: String?, seletedSize: String?) {
        let index = cart.firstIndex { cartGoods in
            return cartGoods.size == seletedSize && cartGoods.color == seletedColor
        }
        
        if let i = index {
            cart[i].quantity += 1
            cart[i].price += goodsDetail.price
        } else {
            cart.append(CartGoods(memberID: memberID, goodsID: goodsDetail.id, quantity: 1, color: seletedColor, size: seletedSize, price: goodsDetail.price))
        }
    }
    
    func removeCart(seletedColor: String?, seletedSize: String?) {
        let index = cart.firstIndex { cartGoods in
            return cartGoods.size == seletedSize && cartGoods.color == seletedColor
        }
        
        if let i = index {
            cart[i].quantity -= 1
            if cart[i].quantity == 0 {
                cart.remove(at: i)
            }
        }
    }
}
