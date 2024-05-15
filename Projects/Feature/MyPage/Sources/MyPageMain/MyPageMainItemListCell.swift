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
    var id: Int { property.id }
    var property: Item

    var isOnAppear = false
    init(property: Item) {
      self.property = property
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case tapped
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        return .none
      case .tapped:
        return .none
      }
    }
  }
}

// MARK: - MyPageMainItemListCellItemable

protocol MyPageMainItemListCellItemable: Identifiable, Equatable {
  var id: Int { get }
  var title: String { get }
  var subTitle: String? { get }
}