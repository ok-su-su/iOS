//
//  CreateEnvelopeProperty.swift
//  Sent
//
//  Created by MaraMincho on 7/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

// MARK: - CreateEnvelopeEventProperty

struct CreateEnvelopeEventProperty: Equatable, Identifiable, CreateEnvelopeSelectItemable {
  var id: Int
  var title: String

  mutating func setTitle(_ val: String) {
    title = val
  }

  init(id: Int, title: String) {
    self.id = id
    self.title = title
  }
}
