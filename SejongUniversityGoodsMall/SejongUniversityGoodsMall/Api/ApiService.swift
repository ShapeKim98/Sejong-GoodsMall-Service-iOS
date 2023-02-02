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
    
    var url: URL? {
        switch self {
            case .server:
                return URL(string: "http://13.125.79.156:5763")
            case .fetchSignUp:
                return URL(string: "auth/signup", relativeTo: APIURL.server.url)
            case .fetchSignIn:
                return URL(string: "auth/signin", relativeTo: APIURL.server.url)
            case .fetchFindEmail:
                return URL(string: "auth/find/email", relativeTo: APIURL.server.url)
            case .fetchGoodsList:
                return URL(string: "items/all", relativeTo: APIURL.server.url)
        }
    }
}

enum ApiError: Error {
    case alreadyEmail
    case authenticationFailure
    case invalidResponse(URLError)
    case jsonDecodeError
    case unknown(Error)
    
    static func convert(error: Error) -> ApiError {
        switch error {
            case is URLError:
                return .invalidResponse(error as! URLError)
            case ApiError.alreadyEmail:
                return .alreadyEmail
            case ApiError.authenticationFailure:
                return .authenticationFailure
            case is DecodingError:
                return .jsonDecodeError
            default:
                return .unknown(error)
        }
    }
}

enum ApiService {
    static func fetchSignUp(email: String, password: String, userName: String, birth: String) -> AnyPublisher<UserResponse, ApiError> {
        let body = UserRequest(email: email, password: password, userName: userName, birth: birth)
        
        var request = URLRequest(url: APIURL.fetchSignUp.url!)
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
        
        var request = URLRequest(url: APIURL.fetchSignIn.url!)
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
        
        var request = URLRequest(url: APIURL.fetchFindEmail.url!)
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
    
    static func fetchGoodsList() -> AnyPublisher<GoodsList, ApiError> {
        let request = URLRequest(url: APIURL.fetchGoodsList.url!)
        
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
}
