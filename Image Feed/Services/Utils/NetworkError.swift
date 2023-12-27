//
//  NetworkError.swift
//  Image Feed
//
//  Created by Аркадий Захаров on 26.12.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parseError
}
