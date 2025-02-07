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

  private func makeReport(_ target: Target) -> String {
    var report = String()
    dump(target, to: &report)
    return report
  }

  /// Async Await용 MoyaProvider
  func request<T: Decodable>(_ target: Target) async throws -> T {
    let report = makeReport(target)
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case let .success(response):
          // statusCode 검사
          if 200 ..< 300 ~= response.statusCode {
            guard let res = try? JSONDecoder.default.decode(T.self, from: response.data) else {
              continuation.resume(throwing: MoyaError.jsonMapping(response))
              return
            }
            continuation.resume(returning: res)
            return
          }
          continuation.resume(throwing: SUSUError(error: MoyaError.statusCode(response), response: response))

        case let .failure(error):
          if let errorDescription = error.errorDescription {
            os_log("report: \(report) \n, errorDescription: \(errorDescription) \n localizedDescription: \(error.localizedDescription)")
          }
          let willSendError: Error = switch error {
          case let .statusCode(response):
            SUSUError(error: error, response: response)

          case let .underlying(error, response):
            SUSUError(error: error, response: response)

          default:
            error
          }
          continuation.resume(throwing: willSendError)
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
  @discardableResult
  func request(_ target: Target) async throws -> Data {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case let .success(response):
          // statusCode 검사
          if 200 ..< 300 ~= response.statusCode {
            continuation.resume(returning: response.data)
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

// MARK: - SUSUError

public struct SUSUError<E: Error>: LocalizedError {
  public var errorDescription: String?
  let error: E
  let response: Moya.Response?
  let errorResponseMessage: String?
  let statusCode: Int?
  let requestData: String?
  let urlString: String?
  let httpMethod: String?

  public init(error: E, response: Moya.Response?) {
    self.error = error
    self.response = response
    requestData = String(data: response?.request?.httpBody, encoding: .utf8)
    statusCode = response?.statusCode
    urlString = response?.request?.url?.absoluteString
    httpMethod = response?.request?.method?.rawValue
    errorResponseMessage = String(data: response?.data, encoding: .utf8)
  }
}

// MARK: - SUSUErrorResponseDTO

struct SUSUErrorResponseDTO: Decodable {
  let errorCode: String
  let reason: String
}

private extension String {
  init?(data: Data?, encoding: String.Encoding) {
    guard let data else {
      return nil
    }
    self.init(data: data, encoding: encoding)
  }
}

// MARK: - Moya.Response + Sendable

extension Moya.Response: @unchecked @retroactive Sendable {}
