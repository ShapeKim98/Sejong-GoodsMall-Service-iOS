//
//  ApiURL.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/08.
//

import Foundation

enum APIURL {
    case server
    case fetchSignUp
    case fetchSignIn
    case fetchFindEmail
    case fetchFindPassword
    case chechAuthNumber
    case updatePassword
    case fetchGoodsList
    case fetchGoodsDetail
    case fetchCategory
    case fetchGoodsListFromCategory
    case sendCartGoods
    case fetchCartGoods
    case deleteCartGoods
    case updateCartGoods
    case sendOrderGoodsFromDetailGoods
    case sendOrderGoodsFromCart
    case fetchOrderGoodsList
    case sendIsScrap
    case deleteIsScrap
    case fetchScrapList
    case userDelete
    
    func url(id: Int? = nil) -> URL? {
        switch self {
            case .server:
                return URL(string: "https://sejonggoodsmall.shop")
            case .fetchSignUp:
                return URL(string: "auth/signup", relativeTo: APIURL.server.url())
            case .fetchSignIn:
                return URL(string: "auth/signin", relativeTo: APIURL.server.url())
            case .fetchFindEmail:
                return URL(string: "auth/find/email", relativeTo: APIURL.server.url())
            case .fetchFindPassword:
                return URL(string: "auth/find/password", relativeTo: APIURL.server.url())
            case .chechAuthNumber:
                return URL(string: "auth/check/authNumber", relativeTo: APIURL.server.url())
            case .updatePassword:
                return URL(string: "auth/update/password", relativeTo: APIURL.server.url())
            case .fetchGoodsList:
                return URL(string: "items/all", relativeTo: APIURL.server.url())
            case .fetchGoodsDetail:
                guard let id = id else {
                    return nil
                }
                
                return URL(string: "items/detail/\(id)", relativeTo: APIURL.server.url())
            case .fetchCategory:
                return URL(string: "categories/all", relativeTo: APIURL.server.url())
            case .fetchGoodsListFromCategory:
                guard let id = id else {
                    return nil
                }
                
                return URL(string: "items?categoryId=\(id)", relativeTo: APIURL.server.url())
            case .sendCartGoods:
                guard let id = id else {
                    return nil
                }
                
                return URL(string: "cart/\(id)", relativeTo: APIURL.server.url())
            case .fetchCartGoods:
                return URL(string: "cart/all", relativeTo: APIURL.server.url())
            case .deleteCartGoods:
                guard let id = id else {
                    return nil
                }
                
                return URL(string: "cart/delete/\(id)", relativeTo: APIURL.server.url())
            case .updateCartGoods:
                return URL(string: "cart/update", relativeTo: APIURL.server.url())
            case .sendOrderGoodsFromDetailGoods:
                guard let id = id else {
                    return nil
                }
                
                return URL(string: "order/\(id)", relativeTo: APIURL.server.url())
            case .sendOrderGoodsFromCart:
                return URL(string: "order/cart", relativeTo: APIURL.server.url())
            case .fetchOrderGoodsList:
                return URL(string: "order/list/all", relativeTo: APIURL.server.url())
            case .sendIsScrap:
                guard let id = id else {
                    return nil
                }
                
                return URL(string: "scrap/\(id)", relativeTo: APIURL.server.url())
            case .deleteIsScrap:
                guard let id = id else {
                    return nil
                }
                
                return URL(string: "scrap/delete/\(id)", relativeTo: APIURL.server.url())
                
            case .fetchScrapList:
                return URL(string: "scrap/list", relativeTo: APIURL.server.url())
            case .userDelete:
                return URL(string: "auth/delete", relativeTo: APIURL.server.url())
        }
    }
}
