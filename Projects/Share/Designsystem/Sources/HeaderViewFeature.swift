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
  public struct State: Equatable, Sendable {
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
  public enum Action: Equatable, Sendable {
    case onAppear
    case tappedDismissButton
    case tappedNotificationButton
    case tappedSearchButton
    case tappedTextButton
    case tappedDoubleTextButton(DoubleTextButtonAction)
    case updateProperty(HeaderViewProperty)

    public enum DoubleTextButtonAction: Sendable {
      case leading
      case trailing
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .updateProperty(property):
        state.updateProperty(property)
        return .none
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

public struct HeaderViewProperty: Equatable, Sendable {
  let title: String
  let type: HeaderViewPropertyType

  public enum IconType: Equatable, Sendable {
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

  public enum HeaderViewPropertyType: Equatable, Sendable {
    case defaultType
    case defaultNonIconType
    case depth2NonIconType

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
    switch type {
    case .defaultNonIconType,
         .defaultType:
      return true
    default:
      return false
    }
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
         .depth2NonIconType,
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
    ZStack {
      makeCenterItem(type: store.state.property.centerItem)

      HStack(alignment: .center) {
        makeLeadingItem(isImage: store.state.property.isLogoImage)
        Spacer()
        makeTrailingItem(type: store.state.property.trailingItem)
      }
      .frame(maxWidth: .infinity, maxHeight: 44)
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
