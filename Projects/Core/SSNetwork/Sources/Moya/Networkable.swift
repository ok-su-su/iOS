//
//  Networkable.swift
//  SSNetwork
//
//  Created by 김건우 on 5/13/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

import Moya

// MARK: - Protocol
protocol Networkable {
    associatedtype Target: TargetType
}

// MARK: - Extensions
extension Networkable {
    
    static func makeProvider() -> MoyaProvider<Target> {
        let loggerPlugin = NetworkLoggerPlugin()
        
        return MoyaProvider<Target>(plugins: [loggerPlugin])
    }
    
}
