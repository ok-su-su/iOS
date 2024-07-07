//
//  SingleSelectButtonItemable.swift
//  SSEditSingleSelectButton
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public protocol SingleSelectButtonItemable: Identifiable, Equatable {
  var id: Int { get set }
  var title: String { get set }
}
