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
    
    @Published var error: ApiError?
    @Published var errorView: ErrorView?
    @Published var goodsList: GoodsList = GoodsList()
    @Published var goodsDetail: Goods = Goods(id: 0, categoryID: 0, categoryName: "", title: "PLACEHOLDER", color: "PLACEHOLDER", size: "PLACEHOLDER", price: 999999, seller: Seller(createdAt: Date(timeIntervalSince1970: 0), modifiedAt: Date(timeIntervalSince1970: 0), id: 0, name: "PLACEHOLDER", phoneNumber: "PLACEHOLDER", accountHolder: "PLACEHOLDER", bank: "PLACEHOLDER", account: "PLACEHOLDER", method: .both), goodsImages: [GoodsImage](), goodsInfos: [GoodsInfo](), description: "PLACEHOLDER", cartItemCount: 0)
    @Published var isGoodsListLoading: Bool = true
    @Published var isGoodsDetailLoading: Bool = true
    @Published var isCategoryLoading: Bool = true
    @Published var isCartGoodsListLoading: Bool = true
    @Published var isSendOrderGoodsLoading: Bool = false
    @Published var message: String?
    @Published var pickUpCart: CartGoodsList = CartGoodsList()
    @Published var deliveryCart: CartGoodsList = CartGoodsList()
    @Published var seletedGoods: CartGoodsRequest = CartGoodsRequest(quantity: 0, cartMethod: .pickUpOrder)
    @Published var categoryList: CategoryList = [Category(id: 0, name: "PLACEHOLDER"),
                                                 Category(id: 1, name: "PLACEHOLDER"),
                                                 Category(id: 2, name: "PLACEHOLDER"),
                                                 Category(id: 3, name: "PLACEHOLDER")
    ]
    @Published var cartGoodsSelections: [Int: Bool] = [Int: Bool]()
    @Published var selectedCartGoodsCount: Int = 0
    @Published var selectedCartGoodsPrice: Int = 0
    @Published var isSendGoodsPossible: Bool = false
    @Published var completeSendCartGoods: Bool = false
    @Published var cartGoodsCount: Int = 0
    @Published var orderType: OrderType = .pickUpOrder
    @Published var orderGoodsListFromCart: CartGoodsList = CartGoodsList()
    @Published var orderGoods: [OrderItem] = [OrderItem]()
    @Published var cartIDList: [Int] = [Int]()
    @Published var orderCompleteGoodsList = OrderGoodsRespnoseList()
    @Published var orderCompleteGoods: OrderGoodsRespnose?
    @Published var isOrderComplete: Bool = false
    
    func fetchGoodsList(id: Int? = nil) {
        ApiService.fetchGoodsList(id: id).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.error = .authenticationFailure
                                self.errorView = ErrorView(retryAction: {})
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsList(id: id)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsList(id: id)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsList(id: id)
                                })
                            }
                            break
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
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsList(id: id)
                                })
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
        ApiService.fetchCategory(token: token).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.error = .authenticationFailure
                                self.errorView = ErrorView(retryAction: { })
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCategory(token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCategory(token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCategory(token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCategory(token: token)
                                })
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
        ApiService.fetchGoodsListFromCategory(id: id).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.error = .authenticationFailure
                                self.errorView = ErrorView(retryAction: { })
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsListFromCatefory(id: id)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsListFromCatefory(id: id)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsListFromCatefory(id: id)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsListFromCatefory(id: id)
                                })
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
        ApiService.fetchGoodsDetail(id: id).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.error = .authenticationFailure
                                self.errorView = ErrorView(retryAction: { })
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsDetail(id: id)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsDetail(id: id)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsDetail(id: id)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchGoodsDetail(id: id)
                                })
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
        
        ApiService.sendCartGoods(goods: seletedGoods, goodsID: goodsDetail.id, token: token).receive(on: DispatchQueue.global(qos: .background)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .alreadyCartGoods:
                            DispatchQueue.main.async {
                                self.message = "이미 장바구니에 있습니다."
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendCartGoodsRequest(token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendCartGoodsRequest(token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendCartGoodsRequest(token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendCartGoodsRequest(token: token)
                                })
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
        ApiService.fetchCartGoods(token: token).subscribe(on: DispatchQueue.global(qos: .userInitiated)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.error = .authenticationFailure
                                self.errorView = ErrorView(retryAction: { })
                            }
                            print("접근 권한 없음")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCartGoods(token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCartGoods(token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCartGoods(token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.fetchCartGoods(token: token)
                                })
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
                        return goods.cartMethod == .pickUpOrder
                    })
                    
                    self.deliveryCart = cartGoodsList.filter({ goods in
                        return goods.cartMethod == .deliveryOrder
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
        
        Publishers.MergeMany(publishers).eraseToAnyPublisher().subscribe(on: DispatchQueue.global(qos: .userInteractive)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .isNoneCartGoods:
                            DispatchQueue.main.async {
                                self.error = .isNoneCartGoods
                                self.message = "존재하지 않는 장바구니 상품"
                            }
                            print("존재하지 않는 장바구니 상품")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteCartGoods(token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteCartGoods(token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteCartGoods(token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteCartGoods(token: token)
                                })
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
        ApiService.deleteCartGoods(id: id, token: token).subscribe(on: DispatchQueue.global(qos: .userInteractive)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .isNoneCartGoods:
                            DispatchQueue.main.async {
                                self.error = .isNoneCartGoods
                                self.message = "존재하지 않는 장바구니 상품"
                            }
                            print("존재하지 않는 장바구니 상품")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteIndividualCartGoods(id: id, token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteIndividualCartGoods(id: id, token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteIndividualCartGoods(id: id, token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.deleteIndividualCartGoods(id: id, token: token)
                                })
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
        ApiService.updateCartGoods(id: id, quantity: quantity, token: token).subscribe(on: DispatchQueue.global(qos: .userInteractive)).retry(1).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .isNoneCartGoods:
                            DispatchQueue.main.async {
                                self.error = .isNoneCartGoods
                                self.message = "존재하지 않는 장바구니 상품"
                            }
                            print("존재하지 않는 장바구니 상품")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.updateCartGoods(id: id, quantity: quantity, token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.updateCartGoods(id: id, quantity: quantity, token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.updateCartGoods(id: id, quantity: quantity, token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.updateCartGoods(id: id, quantity: quantity, token: token)
                                })
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
    
    func sendOrderGoodsFromDetailGoods(buyerName: String, phoneNumber: String, address: Address?, token: String) {
        ApiService.sendOrderGoodsFromDetailGoods(id: self.goodsDetail.id, buyerName: buyerName, phoneNumber: phoneNumber, address: address, orderMethod: self.orderType.rawValue, orderItems: self.orderGoods, token: token).subscribe(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.error = .authenticationFailure
                                self.errorView = ErrorView(retryAction: { })
                                self.isSendOrderGoodsLoading = false
                            }
                            print("접근 권한이 없습니다")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromDetailGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromDetailGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromDetailGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                                self.isSendOrderGoodsLoading = false
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromDetailGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            print("알 수 없는 오류")
                            break
                    }
                case .finished:
                    print("보내기 성공")
                    break
            }
        } receiveValue: { goods in
            DispatchQueue.main.async {
                self.orderGoods.removeAll()
                self.orderGoodsListFromCart.removeAll()
                self.cartIDList.removeAll()
                self.orderCompleteGoods = goods
                self.isSendOrderGoodsLoading = false
                self.isOrderComplete = true
            }
        }
        .store(in: &subscriptions)
    }
    
    func sendOrderGoodsFromCart(buyerName: String, phoneNumber: String, address: Address?, token: String) {
        ApiService.sendOrderGoodsFromCart(cartIDList: self.cartIDList, buyerName: buyerName, phoneNumber: phoneNumber, address: address, orderMethod: self.orderType.rawValue, orderItems: self.orderGoods, token: token).subscribe(on: DispatchQueue.global(qos: .userInitiated)).sink { completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .authenticationFailure:
                            DispatchQueue.main.async {
                                self.error = .authenticationFailure
                                self.errorView = ErrorView(retryAction: { })
                                self.isSendOrderGoodsLoading = false
                            }
                            print("접근 권한이 없습니다")
                            break
                        case .invalidResponse(statusCode: let statusCode):
                            DispatchQueue.main.async {
                                self.error = .invalidResponse(statusCode: statusCode)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromCart(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            break
                        case .cannotNetworkConnect:
                            DispatchQueue.main.async {
                                self.error = .cannotNetworkConnect
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromCart(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            break
                        case .urlError(let error):
                            DispatchQueue.main.async {
                                self.error = .urlError(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromCart(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            break
                        case .jsonDecodeError:
                            DispatchQueue.main.async {
                                self.message = "데이터 디코딩 에러"
                                self.isSendOrderGoodsLoading = false
                            }
                            print("데이터 디코딩 에러")
                            break
                        default:
                            DispatchQueue.main.async {
                                self.error = .unknown(error)
                                self.errorView = ErrorView(retryAction: {
                                    self.error = nil
                                    self.errorView = nil
                                    self.sendOrderGoodsFromCart(buyerName: buyerName, phoneNumber: phoneNumber, address: address, token: token)
                                })
                            }
                            print("알 수 없는 오류")
                            break
                    }
                case .finished:
                    print("보내기 성공")
                    break
            }
        } receiveValue: { goods in
            DispatchQueue.main.async {
                self.orderGoods.removeAll()
                self.orderGoodsListFromCart.removeAll()
                self.cartIDList.removeAll()
                self.orderCompleteGoods = goods
                self.isSendOrderGoodsLoading = false
                self.isOrderComplete = true
            }
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
