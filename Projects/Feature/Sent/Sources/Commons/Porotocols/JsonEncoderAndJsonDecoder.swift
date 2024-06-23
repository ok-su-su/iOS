//
//  JsonEncoderAndJsonDecoder.swift
//  Sent
//
//  Created by MaraMincho on 6/23/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

extension JSONEncoder {
  static let `default`: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    return encoder
  }()
}

extension JSONDecoder {
  static let `default`: JSONDecoder = .init()
}
