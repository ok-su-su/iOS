//
//  SSError.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - Error
enum NetworkError: Error {
  case accessTokenExpired
  case refreshTokenExpired
  case invalidStatudCode
  case jsonDecodingFailure
  case unknown
}

// MARK: - Extensions
extension NetworkError: CustomStringConvertible {
  var description: String {
    switch self {
    case .accessTokenExpired:
      return "ERROR: Access Token Expired"
    case .refreshTokenExpired:
      return "ERROR: Refresh Token Expired"
    case .invalidStatudCode:
      return "ERROR: Invalid Status Code"
    case .jsonDecodingFailure:
      return "ERROR: Json Decoding Failure"
    case .unknown:
      return "ERROR: Unknown"
    }
  }
}
