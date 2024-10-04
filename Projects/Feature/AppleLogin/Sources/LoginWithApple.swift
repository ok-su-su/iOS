//
//  LoginWithApple.swift
//  AppleLogin
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import AuthenticationServices
import Foundation
import OSLog
import SSPersistancy

public final class LoginWithApple: Sendable {
  private static let shared = LoginWithApple()

  static func loginWithApple() {}

  public static let loginWithAppleOnRequest: @Sendable (ASAuthorizationAppleIDRequest) -> Void = { auth in
    // The request object is of the type ASAuthorizationOpenIDRequest and allows us to /
    // set up the contact information to be requested when authenticating /
    // the user by setting up the requested scope.
    auth.requestedScopes = []
    return
  }

  public static let loginWithAppleOnCompletion: @Sendable (Result<ASAuthorization, any Error>) -> Void = { result in
    switch result {
    case let .success(authorization):
      shared.handleSuccessfulLogin(with: authorization)
    case let .failure(error):
      shared.handleLoginError(with: error)
    }
  }

  public static var identityToken: String? {
    guard let data = SSKeychain.shared.load(key: LoginWithApple.Constants.AppleIdentityToken.rawValue),
          let token = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    return token
  }

  public static var userIdentifier: String? {
    guard let data = SSKeychain.shared.load(key: LoginWithApple.Constants.AppleIdentityToken.rawValue),
          let identifier = String(data: data, encoding: .utf8)
    else {
      return nil
    }
    return identifier
  }

  private func handleSuccessfulLogin(with authorization: ASAuthorization) {
    guard let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      return
    }
    let userIdentifier = userCredential.user
    let appleAccessToken = userCredential.identityToken
    if let userIdentifierData = userIdentifier.data(using: .utf8) {
      SSKeychain
        .shared
        .save(key: LoginWithApple.Constants.UserIdentifier.rawValue, data: userIdentifierData)
    }

    if let appleAccessToken {
      SSKeychain
        .shared
        .save(key: LoginWithApple.Constants.AppleIdentityToken.rawValue, data: appleAccessToken)
    }
  }

  private func handleLoginError(with error: Error) {
    os_log("Apple login error occurred \(error.localizedDescription)")
  }

  private enum Constants: String {
    case UserIdentifier
    case AppleIdentityToken
  }
}
