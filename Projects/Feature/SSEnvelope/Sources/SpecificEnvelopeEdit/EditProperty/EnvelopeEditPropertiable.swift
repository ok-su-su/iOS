//
//  EnvelopeEditPropertiable.swift
//  SSEnvelope
//
//  Created by MaraMincho on 10/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

protocol EnvelopeEditPropertiable {
  var isValid: Bool { get }
  var isChanged: Bool { get }
}
