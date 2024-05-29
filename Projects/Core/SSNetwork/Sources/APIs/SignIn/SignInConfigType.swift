//
//  SignInConfigType.swift
//  SSNetwork
//
//  Created by 김건우 on 5/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

protocol SignInConfigType {
    var type: [String: SignInHelperType] { mutating get }
}
