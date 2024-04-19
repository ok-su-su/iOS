//
//  SentMainView.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import Designsystem
import SwiftUI

struct SentMainView: View {
  @Bindable var store: StoreOf<SentMain>

  var body: some View {
    VStack {
      HStack {
        SSButton(Constants.firstButtonProperty) {
          store.send(.tappedFirstButton)
        }
      }
    }
  }

  private enum Constants {
    static let leadingAndTrailingSpacing: CGFloat = 16
    static let filterBadgeTopAndBottomSpacing: CGFloat = 16
    static let firstButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: "최신순"
    )
  }
}
