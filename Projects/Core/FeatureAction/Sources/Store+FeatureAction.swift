//
//  Store+FeatureAction.swift
//  FeatureAction
//
//  Created by MaraMincho on 6/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public extension Store where Action: FeatureAction {
  func sendViewAction(_ action: Action.ViewAction, animation: Animation? = nil) {
    send(.view(action), animation: animation)
  }
}
