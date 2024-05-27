//
//  TermAPIWorker.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final public class TermAPIWorker: Networkable {
  
  // MARK: - Typealias
  typealias Target = TermTarget
  
  // MARK: - Provider
  lazy var provider = makeProvider()
  
  // MARK: - Networking
  public func terms() async throws -> [GetTermResponse] {
    try await provider.request(.terms, of: [GetTermResponse].self)
  }
  
  public func termId(id: Int) async throws -> GetTermInfosResponse {
    try await provider.request(.termId(id: id), of: GetTermInfosResponse.self)
  }
  
}
