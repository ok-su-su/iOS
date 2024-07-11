//
//  NextButtonView.swift
//  SSBottomSelectSheet
//
//  Created by MaraMincho on 7/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//

import Designsystem
import SwiftUI

// MARK: - NextButtonView

struct NextButtonView: View {
  var isAbleToPush: Bool
  let tapAction: () -> Void

  init(isAbleToPush: Bool, tapAction: @escaping () -> Void) {
    self.isAbleToPush = isAbleToPush
    self.tapAction = tapAction
  }

  var body: some View {
    SSButtonWithState(
      .init(
        size: .mh60,
        status: isAbleToPush ? .active : .inactive,
        style: .filled,
        color: .black,
        buttonText: "다음",
        frame: .init(maxWidth: .infinity)
      )
    ) {
      tapAction()
    }
    .background(isAbleToPush ? SSColor.gray100 : SSColor.gray30)
  }
}
