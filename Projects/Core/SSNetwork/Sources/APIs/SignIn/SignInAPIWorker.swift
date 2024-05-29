//
//  SignInAPIWorker.swift
//  SSNetwork
//
//  Created by 김건우 on 5/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import UIKit

final public class SignInAPIWorker {
    
    // MARK: - Config
    private var _config: SignInConfigType = SignInConfig()
    
    // MARK: - SignIn Helpers
    private var signInHelpers: [String: SignInHelperType] {
        _config.type
    }
    
}

extension SignInAPIWorker {
    
    public func signIn(
        _ type: SignInType,
        with viewController: UIViewController
    ) async throws -> Result<TokenResult, Error> {
        guard
            let helper = signInHelpers[type.rawValue]
        else {
            return .failure(NSError())
        }
        
        return .success(
            try await helper.signIn(with: viewController)
        )
    }
    
    public func signOut(
        _ type: SignInType
    ) async throws -> Result<Void, Error> {
        guard
            let helper = signInHelpers[type.rawValue]
        else {
            return .failure(NSError())
        }
        
        return .success(
            try await helper.signOut()
        )
    }
    
}
