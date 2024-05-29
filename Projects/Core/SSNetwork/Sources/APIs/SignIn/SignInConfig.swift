//
//  SignInConfig.swift
//  SSNetwork
//
//  Created by 김건우 on 5/29/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

struct SignInConfig: SignInConfigType {
    
    let apple = SignInType.apple.rawValue
    let google = SignInType.google.rawValue
    let kakao = SignInType.kakao.rawValue
    
    lazy var type: [String: any SignInHelperType] = [
        apple: AppleSignInHelper(),
        google: GoogleSignInHelper(),
        kakao: KakaoSignInHelper()
    ]
}
