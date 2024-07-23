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
import OSLog

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
          // statusCode 검사
          if 200 ..< 300 ~= response.statusCode {
            guard let res = try? JSONDecoder.default.decode(T.self, from: response.data) else {
              let data = String(data: response.data, encoding: .utf8) ?? ""
              os_log("JSON mapping error occurred \n \(data)")
              continuation.resume(throwing: MoyaError.jsonMapping(response))
              return
            }
            continuation.resume(returning: res)
            return
          }
          if let isSUSUError = String(data: response.data, encoding: .utf8) {
            os_log("\(isSUSUError)")
          }
          continuation.resume(with: .failure(MoyaError.statusCode(response)))

        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  func requestData(_ target: Target) async throws -> Data {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case let .success(response):
          // statusCode 검사
          if 200 ..< 300 ~= response.statusCode {
            continuation.resume(returning: response.data)
            return
          }
          if let isSUSUError = String(data: response.data, encoding: .utf8) {
            os_log("\(isSUSUError)")
          }
          continuation.resume(with: .failure(MoyaError.statusCode(response)))

        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }

  /// async방식으로 비동기 요청을 진행합니다. 서버의 response를 따로 mapping하지 않습니다.
  func request(_ target: Target) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case let .success(response):
          // statusCode 검사
          if 200 ..< 300 ~= response.statusCode {
            continuation.resume(returning: ())
            return
          }
          continuation.resume(with: .failure(MoyaError.statusCode(response)))
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}

// MARK: - SUSUErrorResponseDTO

struct SUSUErrorResponseDTO: Decodable {
  let errorCode: String
  let reason: String
}
