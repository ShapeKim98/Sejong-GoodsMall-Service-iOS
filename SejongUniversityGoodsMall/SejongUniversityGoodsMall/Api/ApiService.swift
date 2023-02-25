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
    case fetchGoodsList
    case fetchGoodsDetail
    case fetchCategory
    case fetchGoodsListFromCategory
    case sendCartGoods
    case fetchCartGoods
    case deleteCartGoods
    case updateCartGoods
    case sendOrderGoodsFromDetailGoods
    
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
        }
    }
}

enum ApiError: Error {
    case alreadyEmail
    case authenticationFailure
    case alreadyCartGoods
    case invalidResponse(URLError)
    case jsonDecodeError
    case jsonEncodeError
    case unknown(Error)
    case isNoneCartGoods
    
    static func convert(error: Error) -> ApiError {
        switch error {
            case is URLError:
                return .invalidResponse(error as! URLError)
            case ApiError.alreadyEmail:
                return .alreadyEmail
            case ApiError.authenticationFailure:
                return .authenticationFailure
            case ApiError.alreadyCartGoods:
                return .alreadyCartGoods
            case ApiError.isNoneCartGoods:
                return .isNoneCartGoods
            case is DecodingError:
                return .jsonDecodeError
            case is EncodingError:
                return .jsonEncodeError
            default:
                return .unknown(error)
        }
    }
}

enum ApiService {
    static func fetchSignUp(email: String, password: String, userName: String, birth: String) -> AnyPublisher<UserResponse, ApiError> {
        let body = UserRequest(email: email, password: password, userName: userName, birth: birth)
        
        var request = URLRequest(url: APIURL.fetchSignUp.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badURL)
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.alreadyEmail
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: UserResponse.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchSignIn(email: String, password: String) -> AnyPublisher<LoginResponse, ApiError> {
        let body = LoginRequest(email: email, password: password)
        
        var request = URLRequest(url: APIURL.fetchSignIn.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badURL)
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: LoginResponse.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchFindEmail(userName: String, birth: String) -> AnyPublisher<FindEmailRespnose, ApiError> {
        let body = FindEmailRequest(userName: userName, birth: birth)
        
        var request = URLRequest(url: APIURL.fetchFindEmail.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badURL)
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: FindEmailRespnose.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchGoodsList(id: Int?) -> AnyPublisher<GoodsList, ApiError> {
        let body = GoodsListRequest(memberID: id)
        
        var request = URLRequest(url: APIURL.fetchGoodsList.url()!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse(URLError(.badURL))
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: GoodsList.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchGoodsDetail(id: Int) -> AnyPublisher<Goods, ApiError> {
        let request = URLRequest(url: APIURL.fetchGoodsDetail.url(id: id)!)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse(URLError(.badURL))
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: Goods.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchCategory(token: String) -> AnyPublisher<CategoryList, ApiError> {
        let request = URLRequest(url: APIURL.fetchCategory.url()!)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse(URLError(.badURL))
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: CategoryList.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchGoodsListFromCategory(id: Int) -> AnyPublisher<GoodsList, ApiError> {
        let request = URLRequest(url: APIURL.fetchGoodsListFromCategory.url(id: id)!)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse(URLError(.badURL))
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: GoodsList.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func sendCartGoods(goods: CartGoodsRequest, goodsID: Int, token: String) -> AnyPublisher<Data, ApiError> {
        let body = goods
        
        var request = URLRequest(url: APIURL.sendCartGoods.url(id: goodsID)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badURL)
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
//        .decode(type: CartGoodsResponse.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func fetchCartGoods(token: String) -> AnyPublisher<CartGoodsList, ApiError> {
        var request = URLRequest(url: APIURL.fetchCartGoods.url()!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse(URLError(.badURL))
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .decode(type: CartGoodsList.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func deleteCartGoods(id: Int, token: String) -> AnyPublisher<Data, ApiError> {
        var request = URLRequest(url: APIURL.deleteCartGoods.url(id: id)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        print(request)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            print(Thread.current)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiError.invalidResponse(URLError(.badURL))
            }

            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.isNoneCartGoods
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }

            return data
        }
//        .decode(type: CartGoodsList.self, decoder: JSONDecoder())
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func updateCartGoods(id: Int, quantity: Int, token: String) -> AnyPublisher<Data, ApiError> {
        let body = UpdateCartGoodsRequest(id: id, quantity: quantity)
        
        var request = URLRequest(url: APIURL.updateCartGoods.url()!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badURL)
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.isNoneCartGoods
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
    
    static func sendOrderGoodsFromDetaiGoods(id: Int, buyerName: String, phoneNumber: String, address: Address?, orderItems: [OrderItem], token: String) -> AnyPublisher<Data, ApiError> {
        let body = OrderGoods(buyerName: buyerName, phoneNumber: phoneNumber, address: address, orderItems: orderItems)
        
        var request = URLRequest(url: APIURL.sendOrderGoodsFromDetailGoods.url(id: id)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        return URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badURL)
            }
            
            guard httpResponse.statusCode == 200 else {
                if httpResponse.statusCode == 400 {
                    throw ApiError.authenticationFailure
                } else {
                    print(httpResponse.statusCode)
                    throw URLError(.badServerResponse)
                }
            }
            
            return data
        }
        .mapError { error in
            ApiError.convert(error: error)
        }
        .eraseToAnyPublisher()
    }
}
