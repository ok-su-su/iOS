//
//  CreateEnvelopeEventProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton
import SSNetwork

// MARK: - CreateEnvelopeEventProperty

public typealias CreateEnvelopeEventProperty = CategoryModel

// MARK: SingleSelectButtonItemable

extension CreateEnvelopeEventProperty: SingleSelectButtonItemable {
  public var title: String {
    get { name }
    set { name = newValue }
  }
}
