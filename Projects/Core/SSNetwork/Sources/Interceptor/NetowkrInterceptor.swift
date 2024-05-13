//
//  Interceptor.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    
    /* ✅Moya Plugin, Interceptor 라이프사이클
     * WillSend → Adapt → (Networking) → Retry → DidReceive → Process
     */
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        // TODO: - AccessToken 삽입 및 만료 확인
        completion(.failure(NSError()))
    }
    
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        completion(.doNotRetry)
    }
    
}
