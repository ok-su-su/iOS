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

public struct SentMainView: View {
  @Bindable var store: StoreOf<SentMain>

  public init(store: StoreOf<SentMain>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      HStack(spacing: Constants.topButtonsSpacing) {
        SSButton(Constants.latestButtonProperty) {
          store.send(.tappedFirstButton)
        }
        SSButton(Constants.notSelectedFilterButtonProperty) {
          store.send(.filterButtonTapped)
        }
      }
      .frame(maxWidth: .infinity, alignment: .topLeading)
      .padding(.bottom, Constants.topButtonsSpacing)
      
      
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .padding(.horizontal, Constants.leadingAndTrailingSpacing)
    .background {
      SSColor.gray15
    }
  }

  private enum Constants {
    static let leadingAndTrailingSpacing: CGFloat = 16
    static let filterBadgeTopAndBottomSpacing: CGFloat = 16
    static let topButtonsSpacing: CGFloat = 8

    static let latestButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonOrder),
      buttonText: "최신순"
    )

    static let notSelectedFilterButtonProperty: SSButtonProperty = .init(
      size: .sh32,
      status: .active,
      style: .ghost,
      color: .black,
      leftIcon: .icon(SSImage.commonFilter),
      buttonText: "필터"
    )
  }
}
