//
//  OAuthProvider.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Moya

enum OAuthTarget {
  case login(SignInType, accessToken: String, body: OAuthLoginRequest)
  case signUp(SignInType, accessToken: String, body: OAuthRegisterRequest)
  case signUpVaild(SignInType)
  case retrieve
  
  case logout
  case refresh(body: TokenRefreshRequest)
  case withdraw(code: String, accessToken: String)
}

extension OAuthTarget: BaseTargetType {
  
  var path: String {
    switch self {
    case let .login(type, accessToken, _):
      return "/oauth/\(type.rawValue)/login?accessToken=\(accessToken)"
    case let .signUp(type, accessToken, _):
      return "/oauth/\(type.rawValue)/sign-up?accessToken=\(accessToken)"
    case let .signUpVaild(type):
      return "/oauth/\(type)/sign-up/vaild"
    case .retrieve:
      return "/oauth/oauth"
      
    case .logout:
      return "/auth/logout"
    case .refresh:
      return "/auth/refresh"
    case let .withdraw(code, accessToken):
      return "/auth/withdraw?code=\(code)&accessToken=\(accessToken)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .login:
      return .post
    case .signUp:
      return .post
    case .signUpVaild:
      return .get
    case .retrieve:
      return .get
      
    case .logout:
      return .post
    case .refresh:
      return .post
    case .withdraw:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .login(_, _, body):
      return .requestJSONEncodable(body)
    case let .signUp(_, accessToken, body):
      return .requestJSONEncodable(body)
    case .signUpVaild:
      return .requestPlain
    case .retrieve:
      return .requestPlain
      
    case .logout:
      return .requestPlain
    case let .refresh(body):
      return .requestJSONEncodable(body)
    case .withdraw:
      return .requestPlain
    }
  }
  
}
