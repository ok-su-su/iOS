//
//  OAuthAPIWorker.swift
//  SSNetwork
//
//  Created by 김건우 on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final public class OAuthAPIWorker: Networkable {
  
  // MARK: - Typealias
  typealias Target = OAuthTarget
  
  // MARK: - Provider
  lazy var provider = makeProvider()
  
  // MARK: - Networking
  public func login(
    _ type: SignInType,
    jsonEncodable body: OAuthLoginRequest
  ) async throws -> TokenResponse {
    try await provider.request(
      .login(type, body: body),
      of: TokenResponse.self
    )
  }
  
  public func signUp(
    _ type: SignInType,
    jsonEncodable body: OAuthRegisterRequest
  ) async throws -> TokenResponse {
    try await provider.request(
      .signUp(type, body: body),
      of: TokenResponse.self
    )
  }
  
  public func signUpVaild(
    _ type: SignInType
  ) async throws -> AbleRegisterResponse {
    try await provider.request(
      .signUpVaild(type),
      of: AbleRegisterResponse.self
    )
  }
  
  public func retrieveOAuthInfo() async throws -> UserOAuthInfoResponse {
    try await provider.request(.retrieve, of: UserOAuthInfoResponse.self)
  }
  
}
