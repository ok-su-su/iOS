//
//  Moya+Asynchronous.swift
//  SSNetwork
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Combine
import Foundation
import Moya

extension JSONDecoder {
  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}

public extension MoyaProvider {
  /// Combine용 MoyaProvider
  func requestPublisher<T: Decodable>(_ target: Target) -> AnyPublisher<T, Error> {
    Future<T, Error> { promise in
      self.request(target) { result in
        switch result {
        case let .success(response):
          guard let res = try? JSONDecoder.default.decode(T.self, from: response.data) else {
            promise(.failure(MoyaError.jsonMapping(response)))
            return
          }
          promise(.success(res))
        case let .failure(error):
          promise(.failure(error))
        }
      }
    }.eraseToAnyPublisher()
  }

  /// Async Await용 MoyaProvider
  func request<T: Decodable>(_ target: Target) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case let .success(response):
          guard let res = try? JSONDecoder.default.decode(T.self, from: response.data) else {
            continuation.resume(throwing: MoyaError.jsonMapping(response))
            return
          }
          continuation.resume(returning: res)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
