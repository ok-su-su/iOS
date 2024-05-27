//
//  MoyaProvider.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation

import Moya

// MARK: - Extensions
extension MoyaProvider {
  
  func request<T>(
    _ target: Target,
    callbackQueue queue: DispatchQueue? = nil,
    progressBlock progress: ProgressBlock? = nil,
    decoder: JSONDecoder = JSONDecoder(),
    of type: T.Type
  ) async throws -> T where T: Decodable {
    try await withCheckedThrowingContinuation { continuation in
      self.request(target, callbackQueue: queue, progress: progress) { result in
        switch result {
        case let .success(response):
          guard let response = try? response.filterSuccessfulStatusAndRedirectCodes(),
                let decodedData = try? decoder.decode(type, from: response.data) else {
            continuation.resume(throwing: NetworkError.jsonDecodingFailure)
            return
          }
          continuation.resume(returning: decodedData)
          
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
}
