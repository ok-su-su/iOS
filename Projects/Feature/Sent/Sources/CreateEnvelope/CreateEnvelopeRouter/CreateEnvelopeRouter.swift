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
  @Dependency(\.createEnvelopeNetwork) var network
  @Dependency(\.mainQueue) var queue

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
    case pushAdditionalScreen(AdditionalScreen)
    case pushCreateEnvelopeAdditional
    case dismissScreen
    case changeProgress
  }

  private enum CancelID {
    case dismiss
    case publishNavigation
    case finishEnvelope
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
        return .merge(
          .publisher {
            CreateEnvelopeRouterPublisher
              .shared
              .publisher()
              .receive(on: RunLoop.main)
              .map { val in .push(val) }
          },
          .publisher {
            CreateAdditionalRouterPublisher
              .shared
              .publisher()
              .receive(on: RunLoop.main)
              .map { val in .pushAdditionalScreen(val) }
          }
        )

      case .header(.tappedDismissButton):
        if state.path.count == 1 {
          return .run { _ in await dismiss() }
        }
        return .send(.dismissScreen)
          .throttle(id: CancelID.dismiss, for: 1, scheduler: mainQueue, latest: true)

      case .header:
        return .none

      case .dismissScreen:
        _ = state.path.popLast()
        return .send(.changeProgress)

      case let .pushAdditionalScreen(screenType):
        switch screenType {
        case .selectSection:
          state.createEnvelopeProperty.additionalSectionHelper.startPush()
          state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: nil)
        case .contact:
          state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .contacts)
        case .gift:
          state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .gift)
        case .isVisitedEvent:
          state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .isVisited)
        case .memo:
          state.createEnvelopeProperty.additionalSectionHelper.pushNextSection(from: .memo)
        }
        return .run { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }

        // MARK: Additional Section 분기

      case .pushCreateEnvelopeAdditional:
        // API통신 작업
        guard let currentSection = state.createEnvelopeProperty.additionalSectionHelper.currentSection else {
          return .run { _ in
            let friendProperty = CreateFriendRequestShared.getBody()
            let friendID = try await network.getFriendID(friendProperty)
            CreateEnvelopeRequestShared.setFriendID(id: friendID)
            let createEnvelopeProperty = CreateEnvelopeRequestShared.getBody()
            try await network.createEnvelope(createEnvelopeProperty)

            CreateFriendRequestShared.reset()
            CreateEnvelopeRequestShared.reset()
            await dismiss()
          }.throttle(id: CancelID.finishEnvelope, for: 4, scheduler: queue, latest: false)
        }

        switch currentSection {
        case .isVisited:
          CreateEnvelopeRouterPublisher.shared
            .push(.createEnvelopeAdditionalIsVisitedEvent(.init(isVisitedEventHelper: state.$createEnvelopeProperty.isVisitedHelper)))

        case .gift:
          CreateEnvelopeRouterPublisher.shared
            .push(.createEnvelopeAdditionalIsGift(.init(textFieldText: state.$createEnvelopeProperty.additionIsGiftHelper.textFieldText)))

        case .memo:
          CreateEnvelopeRouterPublisher.shared
            .push(.createEnvelopeAdditionalMemo(.init(memoHelper: state.$createEnvelopeProperty.memoHelper)))
        case .contacts:
          CreateEnvelopeRouterPublisher.shared
            .push(.createEnvelopeAdditionalContact(.init(contactHelper: state.$createEnvelopeProperty.contactHelper)))
        }
        return .none

      case let .push(pathState):
        state.path.append(pathState)
        return .send(.changeProgress, animation: .easeIn(duration: 0.8))

      case .path:
        return .none

      case .changeProgress:
        state.header.updateProperty(.init(type: .depthProgressBar(Double(state.path.count * 12) / 96)))
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
