//
//  SignInHelperType.swift
//  SSNetwork
//
//  Created by 김건우 on 5/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import UIKit

protocol SignInHelperType {
    func signIn(with viewController: UIViewController) async throws -> TokenResult
    func signOut() async throws
}
