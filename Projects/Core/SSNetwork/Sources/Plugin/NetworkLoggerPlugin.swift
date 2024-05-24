//
//  NetworkLoggerPlugIn.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import OSLog

import Moya

struct NetworkLoggerPlugin: PluginType {
  
  // MARK: - WillSend
  func willSend(
    _ request: any RequestType,
    target: any TargetType
  ) {
    guard let httpRequest = request.request else {
      os_log("[HTTP Request] invalid request")
      return
    }
    
    let url = httpRequest.description
    let method = httpRequest.httpMethod ?? "Unkown"
    
    // HTTP Request Summary
    var httpLog = """
        [HTTP Request]
        URL: \(url)
        TARGET: \(target)
        METHOD: \(method)\n
        """
    
    // HTTP Request Header
    httpLog.append("HEADER: [\n")
    httpRequest.allHTTPHeaderFields?.forEach { (key, value) in
      httpLog.append("\t\(key): \(value)\n")
    }
    httpLog.append("]\n")
    
    // HTTP Request Body
    if let body = httpRequest.httpBody,
       let bodyString = String(data: body, encoding: .utf8) {
      httpLog.append("BODY: \n\(bodyString)\n")
    }
    httpLog.append("[HTTP Request End]")
    
    os_log(.default, log: .default, "%@", httpLog)
  }
  
  // MARK: - DidReceive
  func didReceive(
    _ result: Result<Response, MoyaError>,
    target: any TargetType
  ) {
    switch result {
    case let .success(response):
      onSucceed(response, target: target)
    case let .failure(error):
      onFail(error, target: target)
    }
  }
  
  // MARK: - OnSucceed
  func onSucceed(
    _ response: Response,
    target: TargetType) {
      guard let httpRequest = response.request,
            let httpResponse = response.response  else {
        os_log("[HTTP Reqeust] invalid request")
        return
      }
      
      let url = httpRequest.description
      let statusCode = response.statusCode
      
      // HTTP Response Summary
      var httpLog = """
            [HTTP Response]
            TARGET: \(target)
            URL: \(url)
            STATUS CODE: \(statusCode)\n
            """
      
      // HTTP Response Header
      httpLog.append("HEADER: [\n")
      httpResponse.allHeaderFields.forEach { (key, value) in
        httpLog.append("\t\(key): \(value)")
      }
      httpLog.append("]\n")
      
      // HTTP Response Data
      httpLog.append("RESPONSE DATA:\n")
      if let responseString = String(data: response.data, encoding: .utf8) {
        httpLog.append("\(responseString)\n")
      }
      httpLog.append("[HTTP Response End]")
      
      os_log(.default, log: .default, "%@", httpLog)
    }
  
  // MARK: - OnFail
  func onFail(
    _ error: MoyaError,
    target: TargetType
  ) {
    // HTTP Error Summary
    var httpLog = """
        [HTTP Error]
        TARGET: \(target)
        ERROR: \(error.errorCode)\n
        """
    httpLog.append("MESSAGE: \(error.failureReason ?? error.errorDescription ?? "Unknown")\n")
    httpLog.append("[HTTP Error End]")
    
    os_log(.error, log: .default, "%@", httpLog)
  }
  
}
