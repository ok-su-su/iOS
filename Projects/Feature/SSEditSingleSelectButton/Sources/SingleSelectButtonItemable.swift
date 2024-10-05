//
//  SingleSelectButtonItemable.swift
//  SSEditSingleSelectButton
//
//  Created by MaraMincho on 7/7/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Foundation

public protocol SingleSelectButtonItemable: Identifiable, Equatable, Sendable where ID == Int {
  var id: Int { get }
  var title: String { get set }
}
