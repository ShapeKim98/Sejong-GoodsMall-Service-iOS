//
//  OrderItem.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/02/27.
//

import Foundation

struct OrderItem: Codable, Hashable {
    var itemID: Int?
    var color, size: String?
    let quantity, price: Int
    var seller: Seller?
    var deliveryFee: Int?
    let orderStatus: OrderStatus?
    
    enum CodingKeys: String, CodingKey {
        case color, size, quantity, price, seller, deliveryFee, orderStatus
        case itemID = "itemId"
    }
    
    enum OrderStatus: String, Codable {
        case order = "ORDER"
        case comp = "COMP"
        case cancel = "CANCEL"
        
        var kor: String? {
            switch self {
                case .order:
                    return "주문완료"
                case .comp:
                    return "입금환료"
                case .cancel:
                    return "주문취소"
            }
        }
    }
}
