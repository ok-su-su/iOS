//
//  CreateEnvelopeRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import Foundation

// MARK: - CreateEnvelopeRouter

@Reducer
struct CreateEnvelopeRouter {
  @Dependency(\.dismiss) var dismiss

  @ObservableState
  struct State {
    var isOnAppear = false
    var path = StackState<Path.State>()
    var header = HeaderViewFeature.State(.init(type: .depthProgressBar(12 / 96)))
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    init() {
      _createEnvelopeProperty = Shared(.init())
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<Path>)
    case header(HeaderViewFeature.Action)
    case changedPath
    case pushCreateEnvelopeAdditional
    case dismissScreen
  }

  private enum CancelID {
    case dismiss
  }

  @Dependency(\.mainQueue) var mainQueue

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature(enableDismissAction: false)
    }
    Reduce { state, action in
      switch action {
      case .path(.element(id: _, action: .createEnvelopeAdditionalSection(.delegate(.push)))):
        return .run { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }

      case .path(.element(id: _, action: .createEnvelopeDate(.delegate(.push)))):
        state.path.append(.createEnvelopeAdditionalSection(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .run { send in
          await send(.changedPath, animation: .default)
        }

      case .path(.element(id: _, action: .createEnvelopeEvent(.delegate(.push)))):
        state.path.append(.createEnvelopeDate(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .run { send in
          await send(.changedPath, animation: .default)
        }
      case .path(.element(id: _, action: .createEnvelopeRelation(.delegate(.push)))):
        state.path.append(.createEnvelopeEvent(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .run { send in
          await send(.changedPath, animation: .default)
        }
      case .path(.element(id: _, action: .createEnvelopeName(.delegate(.push)))):
        state.path.append(.createEnvelopeRelation(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .run { send in
          await send(.changedPath, animation: .default)
        }

      case .path(.element(id: _, action: .createEnvelopePrice(.delegate(.push)))):
        state.path.append(.createEnvelopeName(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .run { send in
          await send(.changedPath, animation: .default)
        }

      case .onAppear(true):
        state.path.append(.createEnvelopePrice(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .none

      case .header(.tappedDismissButton):
        if state.path.count == 1 {
          return .run { _ in await dismiss() }
        }
        return .send(.dismissScreen)
          .throttle(id: CancelID.dismiss, for: 1, scheduler: mainQueue, latest: true)

      case .dismissScreen:
        _ = state.path.popLast()
        return .send(.changedPath, animation: .default)

      case .changedPath:
        state.header.updateProperty(.init(type: .depthProgressBar(Double(state.path.count * 12) / 96)))
        return .none

      case .pushCreateEnvelopeAdditional:
        state.createEnvelopeProperty.additionalSectionHelper.pushNextSection()
        guard let currentSection = state.createEnvelopeProperty.additionalSectionHelper.currentSection else {
          // end additionSection
          return .none
        }
        switch currentSection {
        case .isVisited:
          state
            .path
            .append(
              .createEnvelopeAdditionalIsVisitedEvent(.init(isVisitedEventHelper: state.$createEnvelopeProperty.isVisitedHelper))
            )
        case .gift:
          state.path.append(.createEnvelopeAdditionalIsGift(.init(textFieldText: state.$createEnvelopeProperty.additionIsGiftHelper.textFieldText)))
        case .memo:
          state.path.append(.createEnvelopeAdditionalMemo(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        case .contacts:
          state.path.append(.createEnvelopeAdditionalContact(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        }
        return .run { send in
          await send(.changedPath, animation: .default)
        }

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }

  private mutating func temp() {}
}

// MARK: CreateEnvelopeRouter.Path

extension CreateEnvelopeRouter {
  @Reducer(state: .equatable, action: .equatable)
  enum Path {
    case createEnvelopePrice(CreateEnvelopePrice)
    case createEnvelopeName(CreateEnvelopeName)
    case createEnvelopeRelation(CreateEnvelopeRelation)
    case createEnvelopeEvent(CreateEnvelopeEvent)
    case createEnvelopeDate(CreateEnvelopeDate)
    case createEnvelopeAdditionalSection(CreateEnvelopeAdditionalSection)
    case createEnvelopeAdditionalMemo(CreateEnvelopeAdditionalMemo)
    case createEnvelopeAdditionalContact(CreateEnvelopeAdditionalContact)
    case createEnvelopeAdditionalIsGift(CreateEnvelopeAdditionalIsGift)
    case createEnvelopeAdditionalIsVisitedEvent(CreateEnvelopeAdditionalIsVisitedEvent)
  }
}
