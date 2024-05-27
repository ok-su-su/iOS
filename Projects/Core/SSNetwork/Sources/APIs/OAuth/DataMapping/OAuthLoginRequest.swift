//
//  OAuthLoginRequest.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct OAuthLoginRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case accessToken
    }
    public var accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}


