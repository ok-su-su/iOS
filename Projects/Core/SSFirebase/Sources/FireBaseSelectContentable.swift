//
//  FireBaseSelectContentable.swift
//  SSFirebase
//
//  Created by MaraMincho on 11/4/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public protocol FireBaseSelectContentable: Sendable {
  var eventParameters: [String: Any] { get }
  var eventName: String { get }
}
