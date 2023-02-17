//
//  GoodsViewModel.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation
import SwiftUI
import Combine

class GoodsViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()

    
    @Published var goodsList: GoodsList = [Goods(id: 0, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading..."),
                                           Goods(id: 1, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading..."),
                                           Goods(id: 2, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading..."),
                                           Goods(id: 3, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, goodsImages: [], goodsInfos: [], description: "loading...")
    ]
    @Published var goodsDetail: Goods = Goods(id: 0, categoryID: 0, categoryName: "loading...", title: "loading...", color: nil, size: nil, price: 99999, goodsImages: [], goodsInfos: [], description: "loading...")
    @Published var isGoodsListLoading: Bool = true
    @Published var isGoodsDetailLoading: Bool = true
    @Published var isCategoryLoading: Bool = true
    @Published var isCartGoodsListLoading: Bool = true
    @Published var message: String?
    @Published var cart: CartGoodsList = [CartGoodsResponse(id: 0, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading...")),
                                          CartGoodsResponse(id: 1, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading...")),
                                          CartGoodsResponse(id: 2, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading..."))
    ]
    @Published var seletedGoods: CartGoodsRequest = CartGoodsRequest(quantity: 0)
    @Published var categoryList: CategoryList = [Category(id: 0, name: "loading..."),
                                                 Category(id: 1, name: "loading..."),
                                                 Category(id: 2, name: "loading..."),
                                                 Category(id: 3, name: "loading...")
    ]
    
    func fetchGoodsList() {
        withAnimation(.spring()) {
            self.isGoodsListLoading = true
        }
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
                withAnimation(.spring()) {
                self.goodsList = goodsList
                    self.isGoodsListLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func fetchCategory(token: String) {
        withAnimation {
            self.isCategoryLoading = true
        }
        ApiService.fetchCategory(token: token).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
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
        } receiveValue: { categoryList in
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.categoryList = categoryList
                    self.categoryList.insert(Category(id: 0, name: "ALLPRODUCT"), at: 0)
                    self.isCategoryLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func fetchGoodsListFromCatefory(id: Int) {
        withAnimation(.spring()) {
            self.isGoodsListLoading = true
        }
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
                withAnimation(.spring()) {
                    self.goodsList = goodsList
                    self.isGoodsListLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func fetchGoodsDetail(id: Int) {
        withAnimation {
            self.isGoodsDetailLoading = true
        }
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
                
                withAnimation {
                    self.isGoodsDetailLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func sendCartGoodsRequest(token: String) {
        ApiService.sendCartGoods(goods: seletedGoods, goodsID: goodsDetail.id, token: token).receive(on: DispatchQueue.global(qos: .background)).sink { completion in
                switch completion {
                    case .failure(let error):
                        switch error {
                            case .alreadyCartGoods:
                                DispatchQueue.main.async {
                                    self.message = "이미 장바구니에 있습니다."
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
                        print("보내기 성공")
                        break
                }
            } receiveValue: { data in
                print(data)
            }
            .store(in: &subscriptions)
    }
    
    func fetchCartGoods(token: String) {
        withAnimation {
            self.isCartGoodsListLoading = true
        }
        
        ApiService.fetchCartGoods(token: token).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
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
        } receiveValue: { cartGoodsList in
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.cart = cartGoodsList
                    self.isCartGoodsListLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func deleteCartGoods(id: Int, token: String) {
//        withAnimation {
//            self.isCartGoodsListLoading = true
//        }
        
        ApiService.deleteCartGoods(id: id, token: token).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            print(Thread.current)
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
                    print("삭제 성공")
                    break
            }
        } receiveValue: { cartGoods in
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.cart = cartGoods
                }
            }
        }
        .store(in: &subscriptions)
    }
}
