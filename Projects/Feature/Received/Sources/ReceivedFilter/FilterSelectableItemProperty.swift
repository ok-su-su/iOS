//
//  FilterSelectableItemProperty.swift
//  Received
//
//  Created by MaraMincho on 8/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation
import SSNetwork

// MARK: - FilterSelectableItemProperty

typealias FilterSelectableItemProperty = CategoryModel

public extension FilterSelectableItemProperty {
  var title: String {
    get { name }
    set { name = newValue }
  }
}
