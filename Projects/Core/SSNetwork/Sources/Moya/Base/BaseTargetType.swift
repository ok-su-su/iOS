//
//  BaseTargetType.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Moya

// MARK: - Protocol
protocol BaseTargetType: TargetType { }

// MARK: - Extensions
extension BaseTargetType {
  
  var baseURL: URL {
    URL(string: Bundle.main.baseUrl)!
  }
  
  var headers: [String : String]? {
    ["Content-Type": "json/application"]
  }
  
  var validationType: ValidationType {
    return .successAndRedirectCodes
  }
  
}



// TODO: - 다른 모듈로 옮기기
public extension Bundle {
    
    var baseUrl: String {
      Bundle.main.infoDictionary?["BaseURL"] as! String
    }
    
}


