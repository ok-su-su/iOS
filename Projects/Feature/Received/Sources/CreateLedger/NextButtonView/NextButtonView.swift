//
//  NextButtonView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

struct NextButtonView: View {
  private var isPushable: Bool
  private var buttonText: String
  private var action: () -> Void

  init(isPushable: Bool, buttonText: String = "다음", action: @escaping () -> Void) {
    self.isPushable = isPushable
    self.action = action
    self.buttonText = buttonText
  }

  var body: some View {
    Button {
      action()
    } label: {
      Text(buttonText)
        .foregroundStyle(SSColor.gray10)
        .frame(maxWidth: .infinity, maxHeight: 60)
    }
    .allowsHitTesting(isPushable)
    .background(isPushable ? SSColor.gray100 : SSColor.gray30)
  }
}
