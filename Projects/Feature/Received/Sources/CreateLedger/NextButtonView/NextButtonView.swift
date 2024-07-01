//
//  NextButtonView.swift
//  Received
//
//  Created by MaraMincho on 7/1/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import SwiftUI
import Designsystem

struct NextButtonView: View {
  var isPushable: Bool
  var action: () -> ()

  init(isPushable: Bool, action: @escaping () -> Void) {
    self.isPushable = isPushable
    self.action = action
  }
  var body: some View {
    Button {
      action()
    } label: {
      Text("다음")
        .foregroundStyle(SSColor.gray10)
    }
    .allowsHitTesting(isPushable)
    .frame(maxWidth: .infinity, maxHeight: 60)
    .background(isPushable ? SSColor.gray100 : SSColor.gray30)
  }
}
