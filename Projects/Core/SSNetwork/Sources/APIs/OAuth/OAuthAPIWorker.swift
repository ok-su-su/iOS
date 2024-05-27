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
    // TODO: - 키체인에서 엑세스 토큰 불러오기
    try await provider.request(
      .login(type, accessToken: "", body: body),
      of: TokenResponse.self
    )
  }
  
  public func signUp(
    _ type: SignInType,
    jsonEncodable body: OAuthRegisterRequest
  ) async throws -> TokenResponse {
    // TODO: - 키체인에서 엑세스 토큰 불러오기
    try await provider.request(
      .signUp(type, accessToken: "", body: body),
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
  
  
  public func logout() async throws -> VoidResponse {
    try await provider.request(.logout, of: VoidResponse.self)
  }
  
  public func refresh() async throws -> TokenResponse {
    // TODO: - 키체인에서 엑세스 토큰, 리프레시 토큰 불러오기
    let tokenRefreshRequest = TokenRefreshRequest(
      accessToken: "",
      refreshToken: ""
    )
    
    return try await provider.request(
      .refresh(body: tokenRefreshRequest),
      of: TokenResponse.self
    )
  }
  
  public func withdraw(code: String) async throws -> VoidResponse {
    // TODO: - 키체인에서 엑세스 토큰 불러오기
    try await provider.request(
      .withdraw(code: code, accessToken: ""),
      of: VoidResponse.self
    )
  }
  
}
