//
//  SSSelectableItemable.swift
//  SSSelectableItems
//
//  Created by MaraMincho on 6/28/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public protocol SSSelectableItemable: Identifiable, Equatable {
  var title: String { get set }
  var id: Int { get }
}
