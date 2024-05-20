// 
//  WriteVote.swift
//  Vote
//
//  Created by MaraMincho on 5/20/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import Foundation
import ComposableArchitecture
import Designsystem

@Reducer
struct WriteVote {

  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var header: HeaderViewFeature.State = .init(.init(title: "새 투표 작성", type: .depth2Text("등록")))
    var helper: WriteVoteProperty = .init()
    init () {}
  }

  enum Action: Equatable, FeatureAction {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }
  
  enum ViewAction: Equatable {
    case onAppear(Bool)
  }

  enum InnerAction: Equatable {}

  enum AsyncAction: Equatable {}

  @CasePathable
  enum ScopeAction: Equatable {}

  enum DelegateAction: Equatable {}

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .view(.onAppear(isAppear)) :
        state.isOnAppear = isAppear
        return .none
      default:
        return .none
      }
    }
  }
}
