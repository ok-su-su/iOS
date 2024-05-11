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
    var path: StackState<Path.State> = .init()
    @Shared var envelopeHistoryRouterHelper: SpecificEnvelopeHistoryRouterHelper
    init() {
      _envelopeHistoryRouterHelper = .init(.init())
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
  }

  @Dependency(\.dismiss) var dismiss
  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        state.isOnAppear = isAppear
        state.path.append(.specificEnvelopeHistoryList(
          .init(envelopeHistoryHelper: state.$envelopeHistoryRouterHelper.specificEnvelopeHistoryListProperty)
        ))
        return .none

      case .path(.push(id: _, state: _)):
        return .none

      case let .path(.element(id: _, action: action)):
        switch action {
        // TODO: - ID를 통한 라우팅하는 흐름구현
        case let .specificEnvelopeHistoryList(.view(.tappedEnvelope(id))):
          state.path.append(.specificEnvelopeHistoryDetail(.init(envelopeDetailProperty: .fakeData())))
          return .none

        case .specificEnvelopeHistoryList(.scope(.header(.tappedDismissButton))):
          return .run { _ in
            await dismiss()
          }

        case .specificEnvelopeHistoryList:
          return .none

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
      }

    }.forEach(\.path, action: \.path)
  }
}

// MARK: SpecificEnvelopeHistoryRouter.Path

extension SpecificEnvelopeHistoryRouter {
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case specificEnvelopeHistoryList(SpecificEnvelopeHistoryList)
    case specificEnvelopeHistoryDetail(SpecificEnvelopeHistoryDetail)
    case specificEnvelopeHistoryEdit(SpecificEnvelopeHistoryEdit)
  }
}
