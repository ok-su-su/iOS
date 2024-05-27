//
//  AbleRegisterResponse.swift
//  SSNetwork
//
//  Created by 김건우 on 5/27/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public struct AbleRegisterResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case canRegister
    }
    var canRegister: Bool
}
