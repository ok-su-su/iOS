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
    case login
    // TODO: - Add Case
}

extension OAuthTarget: BaseTargetType {
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login:
            return .requestPlain
        }
    }
    
}
