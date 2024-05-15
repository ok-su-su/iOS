//
//  OAuthAPIWorker.swift
//  SSNetwork
//
//  Created by 김건우 on 5/15/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

final class OAuthAPIWorker: Networkable {
  
  // MARK: - Typealias
  typealias Target = OAuthTarget
  
  // MARK: - Networking
  func login(_ accessToken: String) async throws -> Data {
    try await makeProvider().request(.login, of: Data.self)
  }
  
}
