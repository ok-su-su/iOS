//
//  SSTokenInterceptor.swift
//  SSNetwork
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Alamofire
import Foundation
import Moya
import OSLog
import SSPersistancy

struct TokenInterceptor: RequestInterceptor {
  let keyChainShared = SSKeychain.shared
  func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
    guard let (accessToken, refreshToken) = getToken() else {
      completion(.success(urlRequest))
      return
    }
    var urlRequest = urlRequest
    urlRequest.setValue(accessToken, forHTTPHeaderField: Constants.accessTokenString)
    urlRequest.setValue(refreshToken, forHTTPHeaderField: Constants.refreshTokenString)

    completion(.success(urlRequest))
  }

  func retry(_ request: Request, for _: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
    guard
      let response = request.task?.response as? HTTPURLResponse,
      response.statusCode == 401
    else {
      completion(.doNotRetryWithError(error))
      return
    }
    refreshTokenWithNetworking(completion)
  }

  func refreshTokenWithNetworking(_ completion: @escaping (RetryResult) -> Void) {
    do {
      let body: Data = try getTokenData()
      let refreshProvider = MoyaProvider<RefreshTokenTargetType>()
      refreshProvider.request(.init(bodyData: body)) { responseResult in
        refreshTokenResponse(result: responseResult, completion: completion)
      }
    } catch {
      completion(.doNotRetryWithError(error))
    }
  }

  func refreshTokenResponse(result: Result<Response, MoyaError>, completion: @escaping (RetryResult) -> Void) {
    do {
      switch result {
      case let .success(response):
        let responseDTO = try response.map(RefreshResponseDTO.self, failsOnEmptyData: true)
        let accessTokenData = try responseDTO.getAccessTokenData()
        let refreshTokenData = try responseDTO.getRefreshTokenData()
        SSKeychain.shared.save(key: Constants.accessTokenString, data: accessTokenData)
        SSKeychain.shared.save(key: Constants.refreshTokenString, data: refreshTokenData)

        completion(.retry)
      case let .failure(error):
        completion(.doNotRetryWithError(error))
      }
    } catch {
      completion(.doNotRetryWithError(error))
    }
  }

  func getToken() -> (accessToken: String, refreshToken: String)? {
    guard let accessTokenData = keyChainShared.load(key: Constants.accessTokenString),
          let refreshTokenData = keyChainShared.load(key: Constants.refreshTokenString)
    else {
      return nil
    }

    let accessToken = String(decoding: accessTokenData, as: UTF8.self)
    let refreshToken = String(decoding: refreshTokenData, as: UTF8.self)
    return (accessToken, refreshToken)
  }

  func getTokenData() throws -> Data {
    guard let (accessToken, refreshToken) = getToken() else {
      throw TokenNetworkingError.noSavedToken
    }
    let body = try jsonEncoder.encode(RefreshRequestBodyDTO(accessToken, refreshToken))
    return body
  }

  let jsonEncoder = JSONEncoder()

  private enum Constants {
    static let accessTokenString = "accessToken"
    static let refreshTokenString = "refreshToken"
  }
}
