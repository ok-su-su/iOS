//
//  LoginWithKakao.swift
//  SSNetwork
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Alamofire

struct TokenInterceptor: RequestInterceptor {
  func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
    var mutableRequest = urlRequest
    mutableRequest.setValue("Token", forHTTPHeaderField: "asdf")
    completion(.success(mutableRequest))
  }

  func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
    
  }
}

