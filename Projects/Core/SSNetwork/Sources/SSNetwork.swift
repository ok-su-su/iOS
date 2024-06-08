//
//  SSNetwork.swift
//  SSNetwork
//
//  Created by MaraMincho on 6/8/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import Alamofire
import Moya

public enum GitHubUserContent {
    case downloadMoyaWebContent(String)
}

extension GitHubUserContent: TargetType {
  public var baseURL: URL {
    return .init(string: "www.naver.com")!
  }
  
  public var path: String {
    ""
  }
  
  public var method: Moya.Method {
    .get
  }
  
  public var task: Moya.Task {
    .requestPlain
  }
  
  public var headers: [String : String]? {
    var tt = ["Content-type": "application/json"]
    
    return ["Content-type": "application/json"]
  }
}

