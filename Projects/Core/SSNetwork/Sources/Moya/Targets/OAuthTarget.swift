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
    case login(SignInType, body: OAuthLoginRequest)
    case signUp(SignInType, body: OAuthRegisterRequest)
    case signUpVaild(SignInType)
    case retrieve
}

extension OAuthTarget: BaseTargetType {
    
    var path: String {
        switch self {
        case let .login(type, _):
            return "/\(type.rawValue)/login"
        case let .signUp(type, _):
            return "/\(type.rawValue)/sign-up"
        case let .signUpVaild(type):
            return "/\(type)/sign-up/vaild"
        case .retrieve:
            return "/oauth/oauth"
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
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .login(_, body):
            return .requestJSONEncodable(body)
        case let .signUp(_, body):
            return .requestJSONEncodable(body)
        case .signUpVaild:
            return .requestPlain
        case .retrieve:
            return .requestPlain
        }
    }
    
}
