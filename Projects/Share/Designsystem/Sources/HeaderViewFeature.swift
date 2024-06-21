//
//  HeaderViewFeature.swift
//  Designsystem
//
//  Created by MaraMincho on 4/17/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

// MARK: - HeaderViewFeature

@Reducer
public struct HeaderViewFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var property: HeaderViewProperty
    var enableDismissAction: Bool

    public mutating func updateProperty(_ property: HeaderViewProperty) {
      self.property = property
    }

    public init(_ property: HeaderViewProperty, enableDismissAction: Bool = true) {
      self.enableDismissAction = enableDismissAction
      self.property = property
    }
  }

  @Dependency(\.dismiss) var dismiss
  public enum Action: Equatable {
    case onAppear
    case tappedDismissButton
    case tappedNotificationButton
    case tappedSearchButton
    case tappedTextButton
    case tappedDoubleTextButton(DoubleTextButtonAction)

    public enum DoubleTextButtonAction {
      case leading
      case trailing
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .tappedDismissButton:
        return .none

      case .tappedNotificationButton:
        return .none

      case .tappedSearchButton:
        return .none

      case .onAppear:
        return .none
      case .tappedTextButton:
        return .none
      case .tappedDoubleTextButton:
        return .none
      }
    }
  }
}

// MARK: - HeaderViewProperty

public struct HeaderViewProperty: Equatable {
  let title: String
  let type: HeaderViewPropertyType

  public enum IconType: Equatable {
    case `default`
    case singleSearch
    case reportIcon

    var image: Image {
      switch self {
      case .default:
        SSImage.commonSearch
      case .singleSearch:
        SSImage.commonSearch
      case .reportIcon:
        SSImage.voteWarning
      }
    }
  }

  public enum HeaderViewPropertyType: Equatable {
    case defaultType
    case defaultNonIconType

    @available(*, deprecated, renamed: "depth2CustomIcon(IconType:)", message: "depth2Icon was deprecated. use depth2CustomIcon plz ")
    case depth2Icon
    case depth2CustomIcon(IconType)
    case depth2Default
    /// 1부터 0 사이의 progress Value를 입력하세요
    case depthProgressBar(Double)
    case depth2Text(String)
    case depth2DoubleText(String, String)
  }

  public init(title: String = "", type: HeaderViewPropertyType) {
    self.title = title
    self.type = type
  }

  var isLogoImage: Bool {
    if case .defaultType = type {
      return true
    }
    return false
  }

  var centerItem: HeaderView.CenterItemTypes {
    return switch type {
    case let .depthProgressBar(double):
      .progress(double)
    default:
      .text(title)
    }
  }

  var trailingItem: HeaderView.trailingItemTypes {
    return switch type {
    case .defaultType:
      .icon(SSImage.commonSearch)
    case let .depth2CustomIcon(icon):
      .icon(icon.image)
    case .defaultNonIconType,
         .depth2Default,
         .depthProgressBar:
      .none
    case let .depth2Text(text):
      .text(text)
    case let .depth2DoubleText(leading, trailing):
      .doubleText(leading, trailing)
    case .depth2Icon:
      .icon(SSImage.commonSearch)
    }
  }
}

// MARK: - HeaderView

public struct HeaderView: View {
  @Environment(\.dismiss) var dismiss
  @Bindable var store: StoreOf<HeaderViewFeature>
  public var body: some View {
    VStack {
      ZStack {
        makeCenterItem(type: store.state.property.centerItem)

        HStack {
          makeLeadingItem(isImage: store.state.property.isLogoImage)
          Spacer()
          makeTrailingItem(type: store.state.property.trailingItem)
        }
        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
      }
    }
    .onAppear {
      store.send(.onAppear)
    }
    .background(Color.clear)
  }

  public init(store: StoreOf<HeaderViewFeature>) {
    self.store = store
  }

  private enum Constants {
    static let headerViewWidth: CGFloat = 56
    static let headerViewHeight: CGFloat = 24
  }
}
