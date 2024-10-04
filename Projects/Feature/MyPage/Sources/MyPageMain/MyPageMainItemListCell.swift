//
//  MypageMainItemListCell.swift
//  MyPage
//
//  Created by MaraMincho on 5/12/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - MyPageMainItemListCell

@Reducer
struct MyPageMainItemListCell<Item: MyPageMainItemListCellItemable> {
  @ObservableState
  struct State: Equatable, Identifiable {
    var title: String
    var subTitle: String?
    var id: Int
    var property: Item

    var isOnAppear = false
    init(property: Item) {
      self.property = property
      id = property.id
      subTitle = property.subTitle
      title = property.title
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case tapped
    case updateSubtitle(String?)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .tapped:
        return .none
      case let .updateSubtitle(text):
        state.subTitle = text
        return .none
      }
    }
  }
}

// MARK: - MyPageMainItemListCellItemable

protocol MyPageMainItemListCellItemable: Identifiable, Equatable, Sendable {
  var id: Int { get }
  var title: String { get }
  var subTitle: String? { get }
}
