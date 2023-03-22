//
//  ApiError.swift
//  SejongUniversityGoodsMall
//
//  Created by 김도형 on 2023/03/08.
//

import Foundation

enum APIError: Error {
    case alreadyEmail
    case authenticationFailure
    case isNoneUser
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
    }
}
