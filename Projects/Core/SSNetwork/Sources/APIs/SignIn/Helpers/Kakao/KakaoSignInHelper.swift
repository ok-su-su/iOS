//
//  KakaoHelper.swift
//  SSNetwork
//
//  Created by 김건우 on 5/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class KakaoSignInHelper: SignInHelperType {
    
    // MARK: - Sign In
    func signIn(with: UIViewController) async throws -> TokenResult {
        if UserApi.isKakaoTalkLoginAvailable() {
            try await signInWithKakaoTalk()
        } else {
            try await signInWithKakaoAccount()
        }
    }
    
    private func signInWithKakaoTalk() async throws -> TokenResult {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                
                if let accessToken = token?.accessToken,
                   let refreshToken = token?.refreshToken {
                    let token = TokenResult(
                        accessToken: accessToken,
                        refershToken: refreshToken
                    )
                    continuation.resume(returning: token)
                }
            }
        }
    }
    
    private func signInWithKakaoAccount() async throws -> TokenResult {
        try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                
                if let accessToken = token?.accessToken,
                   let refreshToken = token?.refreshToken {
                    let token = TokenResult(
                        accessToken: accessToken,
                        refershToken: refreshToken
                    )
                    continuation.resume(returning: token)
                }
            }
        }
    }
    
    
    
    // MARK: - Sign Out
    func signOut() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            UserApi.shared.logout { error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                continuation.resume(returning: ())
            }
        }
    }
    
}
