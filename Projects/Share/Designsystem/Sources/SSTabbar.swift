//
//  SSTabbar.swift
//  Designsystem
//
//  Created by Kim dohyun on 4/18/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import OSLog
import SwiftUI

// MARK: - SSTabType

public enum SSTabType: String, CaseIterable, Equatable, Hashable {
  case envelope
  case received
  case statistics
  case vote
  case mypage

  var title: String {
    switch self {
    case .envelope:
      return "보내요"
    case .received:
      return "받아요"
    case .statistics:
      return "통계"
    case .vote:
      return "투표"
    case .mypage:
      return "마이페이지"
    }
  }

  @ViewBuilder
  func makeImage(isEqualType: Bool) -> some View {
    if isEqualType {
      fillImage
        .resizable()
    } else {
      outlineImage
        .resizable()
    }
  }

  var outlineImage: Image {
    switch self {
    case .envelope:
      return SSImage.envelopeOutline
    case .received:
      return SSImage.inventoryOutline
    case .statistics:
      return SSImage.statisticsOutline
    case .vote:
      return SSImage.voteOutline
    case .mypage:
      return SSImage.mypageOutline
    }
  }

  var fillImage: Image {
    switch self {
    case .envelope:
      return SSImage.envelopeFill
    case .received:
      return SSImage.inventoryFill
    case .statistics:
      return SSImage.statisticsFill
    case .vote:
      return SSImage.voteFill
    case .mypage:
      return SSImage.mypageFill
    }
  }
}

// MARK: - SSTabBarFeature

@Reducer
public struct SSTabBarFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var tabbarType: SSTabType
    var isAppear = true

    public init(tabbarType: SSTabType) {
      self.tabbarType = tabbarType
    }
  }

  public enum Action: Equatable {
    case tappedSection(SSTabType)
    case switchType(SSTabType)
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case let .tappedSection(type):
        switch type {
        case .envelope:
          NotificationCenter.default.post(name: SSNotificationName.tappedEnveloped, object: nil)
        case .received:
          NotificationCenter.default.post(name: SSNotificationName.tappedInventory, object: nil)
        case .statistics:
          NotificationCenter.default.post(name: SSNotificationName.tappedStatistics, object: nil)
        case .vote:
          NotificationCenter.default.post(name: SSNotificationName.tappedVote, object: nil)
        case .mypage:
          NotificationCenter.default.post(name: SSNotificationName.tappedMyPage, object: nil)
        }
        return .none
      case .switchType:
        return .none
      }
    }
  }
}

// MARK: - SSTabbar

public struct SSTabbar: View {
  @Bindable
  var store: StoreOf<SSTabBarFeature>

  public init(store: StoreOf<SSTabBarFeature>) {
    self.store = store
  }

  public var body: some View {
    if store.state.isAppear {
      HStack(alignment: .center) {
        ForEach(SSTabType.allCases, id: \.self) { tabbarType in
          Button {
            store.send(.tappedSection(tabbarType))
          } label: {
            let selectionType = store.tabbarType
            GeometryReader { geometry in
              VStack(alignment: .center, spacing: 4) {
                tabbarType
                  .makeImage(isEqualType: selectionType == tabbarType)
                  .frame(width: 24, height: 24, alignment: .center)

                SSText(text: tabbarType.title, designSystemFont: .title_xxxxs)
                  .bold(true)
                  .foregroundColor(store.tabbarType == tabbarType ? SSColor.gray100 : SSColor.gray40)
              }.frame(width: geometry.size.width, height: geometry.size.height)
            }
          }
        }
      }
    }
  }
}
