//
//  AppleSignInHelper.swift
//  SSNetwork
//
//  Created by 김건우 on 5/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import UIKit

final class AppleSignInHelper: SignInHelperType {
    
    // TODO: - Apple SignIn Code 작성하기
    func signIn(with: UIViewController) async throws -> TokenResult {
        return TokenResult(accessToken: "", refershToken: "")
    }
    
    func signOut() async throws {
        return
    }
    
}
