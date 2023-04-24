//
//  NetworkRequestError.swift
//  Cinematic
//
//  Created by Mohsin Ali Ayub on 10.02.23.
//

import Foundation

enum NetworkRequestError: String, Error {
    case unauthroized = "You made an unauthenticated network request."
    case badRequest
    case forbidden
    case notFound
    case tooManyRequests
    case serverError = "Internal server error."
    case serviceUnavailable = "The service is currently unavailable. Please try again."
    case urlError = "The URL for request is not formed correctly."
    
    /// Throws a network error if the response was not a successful one.
    ///
    /// Checks the status code of `HTTPURLResponse`, and throws appropriate error if the status code is not success.
    static func networkError(from response: HTTPURLResponse?) -> NetworkRequestError? {
        guard let response = response else { return .serverError }
        
        switch response.statusCode {
        case 200:
            return nil
        case 400:
            return .badRequest
        case 401:
            return .unauthroized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 429:
            return .tooManyRequests
        case 503:
            return .serviceUnavailable
        default:
            return .serverError
        }
    }
}
