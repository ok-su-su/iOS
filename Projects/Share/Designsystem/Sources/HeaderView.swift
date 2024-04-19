//
//  HeaderView.swift
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
  @ObservableState
  public struct State: Equatable {
    var property: HeaderViewProperty

    public init(_ property: HeaderViewProperty) {
      self.property = property
    }
  }

  public enum Action {
    case tappedDismissButton
    case tappedNotificationButton
    case tappedSearchButton
  }

  public var body: some Reducer<State, Action> {
    Reduce { _, action in
      switch action {
      case .tappedDismissButton:
        return .run { send in
          await send(.tappedDismissButton)
        }
      case .tappedNotificationButton:
        return .run { send in
          await send(.tappedNotificationButton)
        }
      case .tappedSearchButton:
        return .run { send in
          await send(.tappedSearchButton)
        }
      }
    }
  }
}

// MARK: - HeaderViewProperty

public struct HeaderViewProperty: Equatable, Hashable {
  let title: String
  let type: HeaderViewPropertyType

  public enum HeaderViewPropertyType: Equatable, Hashable {
    case defaultType
    case depth2Icon
    case depth2Default
    case depthProgressBar(Double)
    case depth2Text(String)
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

  var leadingItem: LeadingItem {
    return switch type {
    case .defaultType:
      LeadingItem(isImage: true)
    default:
      LeadingItem(isImage: false)
    }
  }

  var centerItem: CenterItem {
    return switch type {
    case let .depthProgressBar(double):
      .init(type: .progress(double))
    default:
      .init(type: .text(title))
    }
  }

  var trailingItem: TrailingItem {
    return switch type {
    case .defaultType,
         .depth2Icon
         :
      TrailingItem(type: .icon)
    case .depth2Default,
         .depthProgressBar:
      TrailingItem(type: .none)
    case let .depth2Text(text):
      TrailingItem(type: .text(text))
    }
  }
}

// MARK: - HeaderView

public struct HeaderView: View {
  @Bindable var store: StoreOf<HeaderViewFeature>
  public var body: some View {
    VStack {
      ZStack {
        store
          .state
          .property
          .centerItem

        HStack {
          store
            .state
            .property
            .leadingItem

          Spacer()

          store
            .state
            .property
            .trailingItem
        }
        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44)
      }

      Spacer()
    }
  }

  public init(store: StoreOf<HeaderViewFeature>) {
    self.store = store
  }

  private enum Constants {
    static let headerViewWidth: CGFloat = 56
    static let headerViewHeight: CGFloat = 24
  }
}
