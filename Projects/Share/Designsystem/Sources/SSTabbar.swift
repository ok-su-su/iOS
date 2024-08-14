//
//  SSTabbar.swift
//  Designsystem
//
//  Created by Kim dohyun on 4/18/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import OSLog
import SSNotification
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

  func makeImage(isEqualType: Bool) -> Image {
    if isEqualType {
      fillImage
    } else {
      outlineImage
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

  @available(*, deprecated, renamed: "addSSTabBar(Store:)", message: "useViewFunction")
  public init(store: StoreOf<SSTabBarFeature>) {
    self.store = store
  }

  init(_ store: StoreOf<SSTabBarFeature>) {
    self.store = store
  }

  @ViewBuilder
  func makeItem(type tabbarType: SSTabType) -> some View {
    let selectionType = store.tabbarType

    VStack(alignment: .center, spacing: 0) {
      tabbarType
        .makeImage(isEqualType: selectionType == tabbarType)
        .resizable()
        .frame(width: 24, height: 24, alignment: .center)

      Text(tabbarType.title)
        .applySSFont(.title_xxxxs)
        .foregroundColor(store.tabbarType == tabbarType ? SSColor.gray100 : SSColor.gray40)
    }
  }

  @ViewBuilder
  private func makeContentView() -> some View {
    HStack(alignment: .center, spacing: 0) {
      // 1차 배포 탭바
      let items = [SSTabType.envelope, SSTabType.received, SSTabType.statistics, SSTabType.mypage]
      ForEach(items, id: \.self) { tabbarType in
        makeItem(type: tabbarType)
          .frame(maxWidth: .infinity, maxHeight: 56)
          .onTapGesture {
            store.send(.tappedSection(tabbarType))
          }
      }
      // 전체 탭바
      //        ForEach(SSTabType.allCases, id: \.self) { tabbarType in
      //          makeItem(type: tabbarType)
      //            .frame(maxWidth: .infinity, maxHeight: 56)
      //            .onTapGesture {
      //              store.send(.tappedSection(tabbarType))
      //            }
      //        }
    }
  }

  public var body: some View {
    VStack(spacing: 0) {
      SSColor
        .gray20
        .frame(maxWidth: .infinity, maxHeight: 1)
      makeContentView()
    }

    .background(SSColor.gray10)
  }
}

public extension View {
  func addSSTabBar(_ store: StoreOf<SSTabBarFeature>) -> some View {
    safeAreaInset(edge: .bottom) {
      SSTabbar(store)
    }
  }
}
