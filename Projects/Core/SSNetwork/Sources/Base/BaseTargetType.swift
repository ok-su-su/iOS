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



// TODO: - Move other Module
public extension Bundle {
    
    var baseUrl: String {
      Bundle.main.infoDictionary?["BASE_URL"] as! String
    }
    
    var baseDevUrl: String {
      Bundle.main.infoDictionary?["BASE_DEV_URL"] as! String
    }
    
}


