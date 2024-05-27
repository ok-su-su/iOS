//
//  BaseTestTargetType.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Moya

// MARK: - Protocol
protocol BaseDevTargetType: TargetType { }

// MARK: - Extensions
extension BaseDevTargetType {
  
  var baseURL: URL {
    URL(string: Bundle.main.baseDevUrl)!
  }
  
  var headers: [String : String]? {
    ["Content-Type": "json/application"]
  }
  
  var validationType: ValidationType {
    return .successAndRedirectCodes
  }
  
}
