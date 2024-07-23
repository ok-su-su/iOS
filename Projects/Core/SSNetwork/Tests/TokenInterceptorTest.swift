//
//  TokenInterceptorTest.swift
//  SSNetworkTests
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Moya
@testable import SSNetwork
import XCTest

final class TokenInterceptorTest: XCTestCase {
  struct MockHelper: TokenInterceptHelpable {
    func getToken() -> (accessToken: String, refreshToken: String)? {
      return ("AccessToken", "RefreshToken")
    }

    func getTokenData() throws -> Data {
      Data()
    }

    var accessTokenString: String = "AccessToken"
    var refreshTokenString: String = "RefreshToken"
  }

  struct TokenInterceptorTestTarget: TargetType {
    var baseURL: URL = .init(string: "www.susu.com")!
    var path: String = ""
    var method: Moya.Method = .get
    var task: Moya.Task = .requestPlain
    var headers: [String: String]?
  }

  var helper = MockHelper()

  override func setUpWithError() throws {}

  override func tearDownWithError() throws {}

  // TODO: 테스트 할 방법 생각해보기
//  func test_Interceptor() async {
//    // Arrange
//    let customEndpointClosure = { (target: TokenInterceptorTestTarget) -> Endpoint in
//      return Endpoint(
//        url: URL(target: target).absoluteString,
//        sampleResponseClosure: { .networkError(.init(domain: "TokenError", code: 401)) },
//        method: target.method,
//        task: target.task,
//        httpHeaderFields: target.headers
//      )
//    }
//    let provider = MoyaProvider<TokenInterceptorTestTarget>(
//      endpointClosure: customEndpointClosure,
//      stubClosure: MoyaProvider.immediatelyStub,
//      session: .init(interceptor: interceptor)
//    )
//  }
}
