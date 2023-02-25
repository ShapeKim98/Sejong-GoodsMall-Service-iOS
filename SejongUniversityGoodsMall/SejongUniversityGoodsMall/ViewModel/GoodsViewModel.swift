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
    
    @Published var goodsList: GoodsList = [Goods(id: 0, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, seller: Seller(createdAt: "loading...", modifiedAt: "loading...", id: 0, name: "loading...", phoneNumber: "loading...", method: "loading..."), goodsImages: [], goodsInfos: [], description: "loading...", cartItemCount: 0),
                                           Goods(id: 1, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, seller: Seller(createdAt: "loading...", modifiedAt: "loading...", id: 0, name: "loading...", phoneNumber: "loading...", method: "loading..."), goodsImages: [], goodsInfos: [], description: "loading...", cartItemCount: 0),
                                           Goods(id: 2, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, seller: Seller(createdAt: "loading...", modifiedAt: "loading...", id: 0, name: "loading...", phoneNumber: "loading...", method: "loading..."), goodsImages: [], goodsInfos: [], description: "loading...", cartItemCount: 0),
                                           Goods(id: 3, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, seller: Seller(createdAt: "loading...", modifiedAt: "loading...", id: 0, name: "loading...", phoneNumber: "loading...", method: "loading..."), goodsImages: [], goodsInfos: [], description: "loading...", cartItemCount: 0)
    ]
    @Published var goodsDetail: Goods = Goods(id: 0, categoryID: 0, categoryName: "loading...", title: "loading...", color: "loading...", size: "loading...", price: 99999, seller: Seller(createdAt: "loading...", modifiedAt: "loading...", id: 0, name: "loading...", phoneNumber: "loading...", method: "loading..."), goodsImages: [], goodsInfos: [], description: "loading...", cartItemCount: 0)
    @Published var isGoodsListLoading: Bool = true
    @Published var isGoodsDetailLoading: Bool = true
    @Published var isCategoryLoading: Bool = true
    @Published var isCartGoodsListLoading: Bool = true
    @Published var message: String?
    @Published var pickUpCart: CartGoodsList = [CartGoodsResponse(id: 0, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading..."), seller: "loading...", cartMethod: "pickup"),
                                                                                     CartGoodsResponse(id: 1, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading..."), seller: "loading...", cartMethod: "pickup"),
                                                                                     CartGoodsResponse(id: 2, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading..."), seller: "loading...", cartMethod: "pickup")
    ]
    @Published var deliveryCart: CartGoodsList = [CartGoodsResponse(id: 0, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading..."), seller: "loading...", cartMethod: "delivery"),
                                                                                     CartGoodsResponse(id: 1, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading..."), seller: "loading...", cartMethod: "delivery"),
                                                                                     CartGoodsResponse(id: 2, memberID: 0, goodsID: 0, quantity: 0, color: "loading...", size: "loading...", price: 99999, title: "loading...", repImage: RepImage(id: 0, imgName: "loading...", oriImgName: "loading...", imgURL: "loading...", repImgURL: "loading..."), seller: "loading...", cartMethod: "delivery")
    ]
    @Published var seletedGoods: CartGoodsRequest = CartGoodsRequest(quantity: 0)
    @Published var categoryList: CategoryList = [Category(id: 0, name: "loading..."),
                                                 Category(id: 1, name: "loading..."),
                                                 Category(id: 2, name: "loading..."),
                                                 Category(id: 3, name: "loading...")
    ]
    @Published var cartGoodsSelections: [Int: Bool] = [Int: Bool]()
    @Published var selectedCartGoodsCount: Int = 0
    @Published var selectedCartGoodsPrice: Int = 0
    @Published var completeOrderResponseFromDetailGoods: OrderGoods = OrderGoods(buyerName: "loading...", phoneNumber: "loading...", address: nil, orderItems: [])
    @Published var isSendGoodsPossible: Bool = false
    @Published var completeSendCartGoods: Bool = false
    @Published var cartGoodsCount: Int = 0
    @Published var orderType: OrderType = .pickUpOrder
    
    func fetchGoodsList(id: Int? = nil) {
        ApiService.fetchGoodsList(id: id).receive(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
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
                        case .jsonEncodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 인코딩 에러"
                            }
                            print("데이터 인코딩 에러")
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
                    self.cartGoodsCount = goodsList.first?.cartItemCount ?? 0
                    self.isGoodsListLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func fetchCategory(token: String) {
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
        guard isSendGoodsPossible else {
            return
        }
        
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
                DispatchQueue.main.async {
                    withAnimation {
                        self.completeSendCartGoods = true
                    }
                }
            }
            .store(in: &subscriptions)
    }
    
    func fetchCartGoods(token: String) {
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
                    self.pickUpCart = cartGoodsList.filter({ goods in
                        return goods.cartMethod == "pickup"
                    })
                    
                    self.deliveryCart = cartGoodsList.filter({ goods in
                        return goods.cartMethod == "delivery"
                    })
                    
                    self.updateCartData()
                    self.isCartGoodsListLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func deleteCartGoods(token: String) {
        withAnimation {
            self.isCartGoodsListLoading = true
        }
        var publishers = [AnyPublisher<Data, ApiError>]()
        switch orderType {
            case .pickUpOrder:
                self.pickUpCart.forEach { goods in
                    if let isSelected = cartGoodsSelections[goods.id], isSelected {
                        publishers.append(ApiService.deleteCartGoods(id: goods.id, token: token))
                        cartGoodsSelections.removeValue(forKey: goods.id)
                    }
                }
                break
            case .deliveryOrder:
                self.deliveryCart.forEach { goods in
                    if let isSelected = cartGoodsSelections[goods.id], isSelected {
                        publishers.append(ApiService.deleteCartGoods(id: goods.id, token: token))
                        cartGoodsSelections.removeValue(forKey: goods.id)
                    }
                }
        }
        
        Publishers.MergeMany(publishers).eraseToAnyPublisher().receive(on: DispatchQueue.global(qos: .userInteractive)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .isNoneCartGoods:
                            DispatchQueue.main.async {
                                self.message = "존재하지 않는 장바구니 상품"
                            }
                            print("존재하지 않는 장바구니 상품")
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
        } receiveValue: { data in
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.fetchCartGoods(token: token)
                    self.updateCartData()
                    self.isCartGoodsListLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func deleteIndividualCartGoods(id: Int, token: String) {
        ApiService.deleteCartGoods(id: id, token: token).receive(on: DispatchQueue.global(qos: .userInteractive)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .isNoneCartGoods:
                            DispatchQueue.main.async {
                                self.message = "존재하지 않는 장바구니 상품"
                            }
                            print("존재하지 않는 장바구니 상품")
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
        } receiveValue: { data in
            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.fetchCartGoods(token: token)
                    self.updateCartData()
                    self.isCartGoodsListLoading = false
                }
            }
        }
        .store(in: &subscriptions)
    }
    
    func updateCartGoods(id: Int, quantity: Int, token: String) {
        ApiService.updateCartGoods(id: id, quantity: quantity, token: token).receive(on: DispatchQueue.global(qos: .userInteractive)).sink { completion in
                switch completion {
                    case .failure(let error):
                        switch error {
                            case .isNoneCartGoods:
                                DispatchQueue.main.async {
                                    self.message = "존재하지 않는 장바구니 상품"
                                }
                                print("존재하지 않는 장바구니 상품")
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
                DispatchQueue.main.async {
                    self.fetchCartGoods(token: token)
                }
            }
            .store(in: &subscriptions)
    }
    
    func sendOrderGoodsFromDetailGoods(id: Int, buyerName: String, phoneNumber: String, address: Address?, orderItems: [OrderItem], token: String) {
        ApiService.sendOrderGoodsFromDetaiGoods(id: id, buyerName: buyerName, phoneNumber: phoneNumber, address: address, orderItems: orderItems, token: token).sink { completion in
                switch completion {
                    case .failure(let error):
                        switch error {
                            case .authenticationFailure:
                                DispatchQueue.main.async {
                                    self.message = "접근 권한이 없습니다"
                                }
                                print("접근 권한이 없습니다")
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
                
            }
            .store(in: &subscriptions)
    }
    
    func updateCartData() {
        self.selectedCartGoodsCount = 0
        self.selectedCartGoodsPrice = 0
        self.cartGoodsSelections.values.forEach { isSelected in
            self.selectedCartGoodsCount += isSelected ? 1 : 0
        }
        
        switch orderType {
            case .pickUpOrder:
                self.pickUpCart.forEach { goods in
                    selectedCartGoodsPrice += (cartGoodsSelections[goods.id] ?? false) ? goods.price : 0
                }
                break
            case .deliveryOrder:
                self.deliveryCart.forEach { goods in
                    selectedCartGoodsPrice += (cartGoodsSelections[goods.id] ?? false) ? goods.price : 0
                }
                break
        }
        
        
    }
}
