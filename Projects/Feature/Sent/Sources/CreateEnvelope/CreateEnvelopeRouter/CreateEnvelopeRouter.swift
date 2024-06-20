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
import OSLog

// MARK: - CreateEnvelopeRouter

@Reducer
struct CreateEnvelopeRouter {
  @Dependency(\.dismiss) var dismiss

  @ObservableState
  struct State {
    var isOnAppear = false
    var path = StackState<PathDestination.State>()
    var header = HeaderViewFeature.State(.init(type: .depthProgressBar(12 / 96)), enableDismissAction: false)
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty

    init() {
      _createEnvelopeProperty = Shared(.init())
    }
  }

  enum Action: Equatable {
    case onAppear(Bool)
    case path(StackActionOf<PathDestination>)
    case header(HeaderViewFeature.Action)
    case push(PathDestination.State)
    case pushCreateEnvelopeAdditional
    case dismissScreen
    case changeProgress
  }

  private enum CancelID {
    case dismiss
    case publishNavigation
  }

  @Dependency(\.mainQueue) var mainQueue

  init() {
    // TODO...
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }

    Reduce { state, action in
      switch action {
      case let .onAppear(val):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = val
        state.path.append(.createEnvelopePrice(.init(createEnvelopeProperty: state.$createEnvelopeProperty)))
        return .publisher {
          CreateEnvelopeRouterPublisher
            .shared
            .publisher()
            .receive(on: RunLoop.main)
            .map { val in .push(val) }
        }

      case .header(.tappedDismissButton):
        if state.path.count == 1 {
          return .run { _ in await dismiss() }
        }
        return .send(.dismissScreen)
          .throttle(id: CancelID.dismiss, for: 1, scheduler: mainQueue, latest: true)

      case .dismissScreen:
        _ = state.path.popLast()
        let pathCount = state.path.count
        os_log("Path의갯수는? \(pathCount)")
        return .send(.changeProgress)

        // MARK: Additional Section 분기

      case .path(.element(id: _, action: .createEnvelopeAdditionalSection(.delegate(.push)))):
        state.createEnvelopeProperty.additionalSectionHelper.startPush()
        state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: nil)
        return .run { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }

      case .path(.element(id: _, action: .createEnvelopeAdditionalContact(.delegate(.push)))):
        state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .contacts)
        return .run { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }

      case .path(.element(id: _, action: .createEnvelopeAdditionalIsGift(.delegate(.push)))):
        state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .gift)
        return .run { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }

      case .path(.element(id: _, action: .createEnvelopeAdditionalIsVisitedEvent(.delegate(.push)))):
        state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .isVisited)
        return .run { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }

      case .path(.element(id: _, action: .createEnvelopeAdditionalMemo(.delegate(.push)))):
        state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .memo)
        return .run { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }
      case .pushCreateEnvelopeAdditional:
        guard let currentSection = state.createEnvelopeProperty.additionalSectionHelper.currentSection else {
          return .run { _ in await dismiss() }
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
          state.path.append(.createEnvelopeAdditionalMemo(.init(memoHelper: state.$createEnvelopeProperty.memoHelper)))
        case .contacts:
          state.path.append(.createEnvelopeAdditionalContact(.init(contactHelper: state.$createEnvelopeProperty.contactHelper)))
        }
        return .none

      case let .push(pathState):
        state.path.append(pathState)
        return .send(.changeProgress)

      case .changeProgress:
        state.header.updateProperty(.init(type: .depthProgressBar(Double(state.path.count * 12) / 96)))
        return .none
      default:
        return .none
      }
    }
    .addFeatures()
  }
}

extension Reducer where State == CreateEnvelopeRouter.State, Action == CreateEnvelopeRouter.Action {
  func addFeatures() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}

// MARK: - CreateEnvelopeRouter.Path

extension CreateEnvelopeRouter {
  @CasePathable
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
