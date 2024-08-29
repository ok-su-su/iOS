//
//  CreateEnvelopeRelationItemProperty.swift
//  SSEnvelope
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSEditSingleSelectButton
import SSNetwork
import SSSelectableItems

public typealias CreateEnvelopeRelationItemProperty = RelationshipModel

// MARK: SingleSelectButtonItemable

extension CreateEnvelopeRelationItemProperty: SingleSelectButtonItemable {
  public var title: String {
    get { relation }
    set { relation = newValue }
  }

  mutating func setTitle(_ val: String) {
    relation = val
  }
}
