//
//  MyPageMainNetwork.swift
//  MyPage
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Moya
import SSNetwork
import Dependencies
import SSInterceptor

final class MyPageMainNetwork {
  private let provider = MoyaProvider<Network>(session: .init(interceptor: SSTokenInterceptor.shared))
  
  func getMyInformation() async throws -> UserInfoResponseDTO {
    return try await provider.request(.myPageInformation)
  }
}


extension DependencyValues {
  var myPageMainNetwork: MyPageMainNetwork {
    get { self[MyPageMainNetwork.self] }
    set { self[MyPageMainNetwork.self] = newValue }
  }
}
extension MyPageMainNetwork: DependencyKey {
  static var liveValue: MyPageMainNetwork = .init()
  private enum Network: SSNetworkTargetType {
    case myPageInformation
    
    var additionalHeader: [String : String]? { return nil }
    var path: String {
      switch self {
      case .myPageInformation:
        "users/my-info"
      }
    }
    
    var method: Moya.Method { 
      switch self {
      case .myPageInformation:
          .get
      }
    }
    
    var task: Moya.Task {
      switch self {
      case .myPageInformation:
          .requestPlain
      }
    }
  }
}

struct UserInfoResponseDTO: Equatable, Decodable {
  // 내 아이디
  let id: Int64
  // 내 이름
  let name: String
  // 성별 M: 남자, W 여자
  let gender: String
  // 출생 년도
  let birth: Int
}
