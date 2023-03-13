//
//  ApiService.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation
import Combine

enum APIService {
    static func fetchSignUp(email: String, password: String, userName: String, birth: String) -> AnyPublisher<UserResponse, APIError> {
        let body = UserRequest(email: email, password: password, userName: userName, birth: birth)
        
        var request = URLRequest(url: APIURL.fetchSignUp.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.alreadyEmail
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: UserResponse.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchSignIn(email: String, password: String) -> AnyPublisher<LoginResponse, APIError> {
        let body = LoginRequest(email: email, password: password)
        
        var request = URLRequest(url: APIURL.fetchSignIn.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: LoginResponse.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchFindEmail(userName: String, birth: String) -> AnyPublisher<FindEmailRespnose, APIError> {
        let body = FindEmailRequest(userName: userName, birth: birth)
        
        var request = URLRequest(url: APIURL.fetchFindEmail.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.isNoneUser
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: FindEmailRespnose.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchGoodsList(token: String? = nil) -> AnyPublisher<GoodsList, APIError> {
        var request = URLRequest(url: APIURL.fetchGoodsList.url()!)
        
        if let bearerToken = token {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: GoodsList.self, decoder: decoder)
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchGoodsDetail(id: Int, token: String? = nil) -> AnyPublisher<Goods, APIError> {
        var request = URLRequest(url: APIURL.fetchGoodsDetail.url(id: id)!)
        
        if let bearerToken = token {
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        }
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: Goods.self, decoder: decoder)
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchCategory() -> AnyPublisher<CategoryList, APIError> {
        let request = URLRequest(url: APIURL.fetchCategory.url()!)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: CategoryList.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchGoodsListFromCategory(id: Int) -> AnyPublisher<GoodsList, APIError> {
        let request = URLRequest(url: APIURL.fetchGoodsListFromCategory.url(id: id)!)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: GoodsList.self, decoder: decoder)
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func sendCartGoods(goods: CartGoodsRequest, goodsID: Int, token: String) -> AnyPublisher<Data, APIError> {
        let body = goods
        
        var request = URLRequest(url: APIURL.sendCartGoods.url(id: goodsID)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchCartGoods(token: String) -> AnyPublisher<CartGoodsList, APIError> {
        var request = URLRequest(url: APIURL.fetchCartGoods.url()!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: CartGoodsList.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func deleteCartGoods(id: Int, token: String) -> AnyPublisher<CartGoodsList, APIError> {
        var request = URLRequest(url: APIURL.deleteCartGoods.url(id: id)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }

            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.isNoneCartGoods
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }

            return data
        }
        .decode(type: CartGoodsList.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func updateCartGoods(id: Int, quantity: Int, token: String) -> AnyPublisher<Data, APIError> {
        let body = UpdateCartGoodsRequest(id: id, quantity: quantity)
        
        var request = URLRequest(url: APIURL.updateCartGoods.url()!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.isNoneCartGoods
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func sendOrderGoodsFromDetailGoods(id: Int, buyerName: String, phoneNumber: String, address: Address?, orderMethod: String, deliveryRequest: String?, orderItems: [OrderItem], token: String) -> AnyPublisher<OrderGoodsRespnose, APIError> {
        let body = OrderGoodsRequestFromDetailGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: address, orderMethod: orderMethod, deliveryRequest: deliveryRequest, orderItems: orderItems)
        
        var request = URLRequest(url: APIURL.sendOrderGoodsFromDetailGoods.url(id: id)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: OrderGoodsRespnose.self, decoder: decoder)
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func sendOrderGoodsFromCart(cartIDList: [Int], buyerName: String, phoneNumber: String, address: Address?, orderMethod: String, deliveryRequset: String?, orderItems: [OrderItem], token: String) -> AnyPublisher<OrderGoodsRespnose, APIError> {
        let body = OrderGoodsRequestFromCart(buyerName: buyerName, phoneNumber: phoneNumber, address: address, orderMethod: orderMethod, deliveryRequest: deliveryRequset, cartIDList: cartIDList)
        
        var request = URLRequest(url: APIURL.sendOrderGoodsFromCart.url()!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: OrderGoodsRespnose.self, decoder: decoder)
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchOrderGoodsList(token: String) -> AnyPublisher<OrderGoodsRespnoseList, APIError> {
        var request = URLRequest(url: APIURL.fetchOrderGoodsList.url()!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: OrderGoodsRespnoseList.self, decoder: decoder)
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func sendIsScrap(id: Int, token: String) -> AnyPublisher<Scrap, APIError> {
        var request = URLRequest(url: APIURL.sendIsScrap.url(id: id)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: Scrap.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func deleteIsScrap(id: Int, token: String) -> AnyPublisher<Scrap, APIError> {
        var request = URLRequest(url: APIURL.deleteIsScrap.url(id: id)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: Scrap.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchScrapList(token: String) -> AnyPublisher<ScrapGoodsList, APIError> {
        var request = URLRequest(url: APIURL.fetchScrapList.url()!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.authenticationFailure
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .decode(type: ScrapGoodsList.self, decoder: JSONDecoder())
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchFindPassword(userName: String, email: String) -> AnyPublisher<Data, APIError> {
        let body = FindPasswordRequest(name: userName, email: email)
        
        var request = URLRequest(url: APIURL.fetchFindPassword.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.isNoneUser
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func checkAuthNumber(email: String, inputNum: Int) -> AnyPublisher<Data, APIError> {
        let body = AuthNumberRequest(email: email, inputNum: inputNum)
        
        var request = URLRequest(url: APIURL.chechAuthNumber.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.isInvalidAuthNumber
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func updatePassword(email: String, password: String) -> AnyPublisher<Data, APIError> {
        let body = UpdatePasswordRequest(email: email, password: password)
        
        var request = URLRequest(url: APIURL.updatePassword.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.cannotNetworkConnect
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw APIError.isNoneEmail
                } else {
                    throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
                }
            }
            
            return data
        }
        .mapError { error in
            APIError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
}
