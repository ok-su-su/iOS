//
//  GoogleHelper.swift
//  SSNetwork
//
//  Created by 김건우 on 5/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import UIKit

final class GoogleSignInHelper: SignInHelperType {
    
    // TODO: - Google SignIn Code 작성하기
    func signIn(
        with viewController: UIViewController
    ) async throws -> TokenResult {
        return TokenResult(accessToken: "", refershToken: "")
    }
    
    func signOut() async throws {
        return
    }
    
}
