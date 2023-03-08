//
//  ApiService.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/01/29.
//

import Foundation
import Combine

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
    
    func url(id: Int? = nil) -> URL? {
        switch self {
            case .server:
                return URL(string: "http://13.125.79.156:5763")
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
        }
    }
}

enum APIError: Error {
    case alreadyEmail
    case authenticationFailure
    case isNoneEmail
    case isInvalidAuthNumber
    case alreadyCartGoods
    case invalidResponse(statusCode: Int)
    case cannotNetworkConnect
    case jsonDecodeError
    case jsonEncodeError
    case isNoneCartGoods
    case urlError(URLError)
    case unknown(Error)
    
    static func convert(error: Error) -> APIError {
        switch error {
            case is APIError:
                return error as! APIError
            case is URLError:
                return .urlError(error as! URLError)
            case is DecodingError:
                return .jsonDecodeError
            case is EncodingError:
                return .jsonEncodeError
            default:
                return .unknown(error)
        }
    }}

enum ApiService {
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
                    throw APIError.isNoneEmail
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
    
    static func deleteCartGoods(id: Int, token: String) -> AnyPublisher<Data, APIError> {
        var request = URLRequest(url: APIURL.deleteCartGoods.url(id: id)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        print(request)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            print(Thread.current)
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
