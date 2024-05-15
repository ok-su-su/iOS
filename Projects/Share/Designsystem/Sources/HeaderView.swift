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
  var enableDismissAction: Bool
  public init(enableDismissAction: Bool = true) {
    self.enableDismissAction = enableDismissAction
  }

  @ObservableState
  public struct State: Equatable {
    var property: HeaderViewProperty

    public init(_ property: HeaderViewProperty) {
      self.property = property
    }

    public mutating func updateProperty(_ property: HeaderViewProperty) {
      self.property = property
    }
  }

  @Dependency(\.dismiss) var dismiss
  public enum Action: Equatable {
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
        return .run { [enableDismissAction] _ in
          if enableDismissAction {
            await dismiss()
          }
        }
      case .tappedNotificationButton:
        return .none
      case .tappedSearchButton:
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

public struct HeaderViewProperty: Equatable, Hashable {
  let title: String
  let type: HeaderViewPropertyType

  public enum HeaderViewPropertyType: Equatable, Hashable {
    case defaultType
    case depth2Icon
    case depth2Default
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
    case .defaultType,
         .depth2Icon
         :
      .icon
    case .depth2Default,
         .depthProgressBar:
      .none
    case let .depth2Text(text):
      .text(text)
    case let .depth2DoubleText(leading, trailing):
      .doubleText(leading, trailing)
    }
  }
}

// MARK: - HeaderView

public struct HeaderView: View {
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
  }

  public init(store: StoreOf<HeaderViewFeature>) {
    self.store = store
  }

  private enum Constants {
    static let headerViewWidth: CGFloat = 56
    static let headerViewHeight: CGFloat = 24
  }
}
