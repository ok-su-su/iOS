//
//  CreateRelationItemProperty.swift
//  Sent
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeRelationItemProperty

struct CreateEnvelopeRelationItemProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  var id: Int
  var title: String

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }

  mutating func setTitle(_ val: String) {
    title = val
  }
}
