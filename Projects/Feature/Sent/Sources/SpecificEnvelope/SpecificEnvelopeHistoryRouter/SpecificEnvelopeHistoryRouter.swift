//
//  SpecificEnvelopeHistoryRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/10/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Foundation

// MARK: - SpecificEnvelopeHistoryRouter

@Reducer
struct SpecificEnvelopeHistoryRouter {
  @ObservableState
  struct State {
    var isOnAppear = false
    var path: StackState<SpecificEnvelopeHistoryRouterPath.State> = .init()
    var envelopeHistory: SpecificEnvelopeHistoryList.State
    @Shared var envelopeHistoryRouterHelper: SpecificEnvelopeHistoryRouterHelper
    init(envelopeProperty: EnvelopeProperty) {
      _envelopeHistoryRouterHelper = .init(.init())
      envelopeHistory = .init(envelopeProperty: envelopeProperty)
    }
  }

  enum Action: Equatable {
    case path(StackActionOf<SpecificEnvelopeHistoryRouterPath>)
    case envelopeHistory(SpecificEnvelopeHistoryList.Action)
  }

  @Dependency(\.dismiss) var dismiss
  var body: some Reducer<State, Action> {
    Scope(state: \.envelopeHistory, action: \.envelopeHistory) {
      SpecificEnvelopeHistoryList()
    }
    Reduce { state, action in
      switch action {
      case .path(.push(id: _, state: _)):
        return .none

      case let .path(.element(id: _, action: action)):
        switch action {
        // TODO: - ID를 통한 라우팅하는 흐름구현
//        case let .specificEnvelopeHistoryList(.view(.tappedEnvelope(id))):
//          state.path.append(.specificEnvelopeHistoryDetail(.init(envelopeDetailProperty: .fakeData())))
//          return .none
//
//        case .specificEnvelopeHistoryList(.scope(.header(.tappedDismissButton))):
//          return .run { _ in
//            await dismiss()
//          }
//
//        case .specificEnvelopeHistoryList:
//          return .none

        case .specificEnvelopeHistoryDetail(.inner(.editing)):
          state.path.append(
            .specificEnvelopeHistoryEdit(
              SpecificEnvelopeHistoryEdit.State(
                editHelper: state.$envelopeHistoryRouterHelper.envelopeHistoryEditHelper
              )
            )
          )
          return .none
        case .specificEnvelopeHistoryDetail:
          return .none

        case .specificEnvelopeHistoryEdit:
          return .none
        }

      case let .path(.popFrom(id: id)):
        return .none
      case .envelopeHistory:
        return .none
      }

    }.forEach(\.path, action: \.path)
  }
}

// MARK: - SpecificEnvelopeHistoryRouterPath

@Reducer(state: .equatable, action: .equatable)
enum SpecificEnvelopeHistoryRouterPath {
  case specificEnvelopeHistoryDetail(SpecificEnvelopeHistoryDetail)
  case specificEnvelopeHistoryEdit(SpecificEnvelopeHistoryEdit)
}
