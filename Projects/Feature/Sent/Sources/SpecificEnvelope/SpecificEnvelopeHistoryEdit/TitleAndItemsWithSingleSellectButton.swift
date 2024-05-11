// 
//  TitleAndItemsWithSingleSellectButton.swift
//  Sent
//
//  Created by MaraMincho on 5/11/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture

@Reducer
struct TitleAndItemsWithSingleSelectButton<Item: SingeSelectButtonItemable> {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    @Shared var singleSelectButtonHelper: SingleSelectButtonHelper<Item>
    init(singleSelectButtonHelper: Shared<SingleSelectButtonHelper<Item>>) {
      self._singleSelectButtonHelper = singleSelectButtonHelper
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case tappedID(UUID)
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear) :
        state.isOnAppear = isAppear
        return .none
      case let .tappedID(id) :
        state.singleSelectButtonHelper.selectItem(by: id)
        return .none
      }
    }
  }
}
