//
//  CreateEnvelopeRouter.swift
//  Sent
//
//  Created by MaraMincho on 5/2/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Designsystem
import Foundation
import SSFirebase

// MARK: - CreateEnvelopeRouter

@Reducer
struct CreateEnvelopeRouter: @unchecked Sendable {
  @Dependency(\.createEnvelopeNetwork) var network

  @ObservableState
  struct State: Equatable, Sendable {
    var type: CreateEnvelopeInitialType
    var isOnAppear = false
    var path = StackState<CreateEnvelopePath.State>()
    var header = HeaderViewFeature.State(.init(type: .depthProgressBar(12 / 96)), enableDismissAction: false)
    var dismiss = false
    @Shared var createEnvelopeProperty: CreateEnvelopeProperty
    var isLoading = false

    var currentCreateEnvelopeData: Data = .init()

    var createPrice: CreateEnvelopePrice.State

    init(type: CreateEnvelopeInitialType) {
      self.type = type
      _createEnvelopeProperty = Shared(.init())
      createPrice = .init(createEnvelopeProperty: _createEnvelopeProperty)
    }
  }

  enum Action: Equatable, Sendable {
    case onAppear(Bool)
    case path(StackActionOf<CreateEnvelopePath>)
    case header(HeaderViewFeature.Action)
    case push(CreateEnvelopePath.State)
    case pushAdditionalScreen(AdditionalScreen)
    case pushCreateEnvelopeAdditional
    case changeProgress
    case createPrice(CreateEnvelopePrice.Action)
    case dismiss(Bool)
    case updateDismissData(Data)
    case isLoading(Bool)
    case dismissScreen
    case none
  }

  private enum CancelID: Hashable, Sendable {
    case dismiss
    case publishNavigation
    case finishEnvelope
    case onAppearCancelID
  }

  @Dependency(\.dismiss) var dismiss

  init() {}

  private func requestCreateEnvelope() -> Effect<Action> {
    return .ssRun { send in
      let friendProperty = CreateFriendRequestShared.getBody()
      await send(.isLoading(true))
      if CreateEnvelopeRequestShared.getFriendID() == nil {
        let friendID = try await network.getFriendID(friendProperty)
        CreateEnvelopeRequestShared.setFriendID(id: friendID)
      }

      let createEnvelopeProperty = CreateEnvelopeRequestShared.getBody()
      let envelopeData = try await network.createEnvelope(createEnvelopeProperty)
      await send(.updateDismissData(envelopeData))
      await send(.isLoading(false))

      CreateFriendRequestShared.reset()
      CreateEnvelopeRequestShared.reset()

      await send(.dismiss(true))
    }
  }

  private func pushWithCrateTypeAndState(
    _ type: CreateEnvelopeInitialType,
    fromState state: CreateEnvelopePath.State,
    createEnvelopeProperty: Shared<CreateEnvelopeProperty>
  ) {
    switch state {
    case .createEnvelopePrice:
      switch type {
      case .sentWithFriendID:
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeEvent(.init(createEnvelopeProperty)))
      case .received,
           .sent:
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeName(.init(createEnvelopeProperty)))
      }

    case .createEnvelopeName:
      CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeRelation(.init(createEnvelopeProperty)))

    case .createEnvelopeRelation:
      switch type {
      case .sent,
           .sentWithFriendID:
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeEvent(.init(createEnvelopeProperty)))

      case .received:
        CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeDate(.init(createEnvelopeProperty)))
      }

    case .createEnvelopeEvent:
      CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeDate(.init(createEnvelopeProperty)))

    case .createEnvelopeDate:
      let nextPathState: CreateEnvelopeAdditionalSection.State = switch type {
      case .sentWithFriendID:
        .init(createEnvelopeProperty, createType: .items([.isVisited, .gift, .memo]))
      case .received,
           .sent:
        .init(createEnvelopeProperty, createType: .default)
      }
      CreateEnvelopeRouterPublisher.shared.push(.createEnvelopeAdditionalSection(nextPathState))

    default:
      break
    }
  }

  @Dependency(\.mainQueue) var throttleQueue
  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    Scope(state: \.createPrice, action: \.createPrice) {
      CreateEnvelopePrice()
    }

    Reduce { state, action in
      switch action {
      case .none:
        return .none

      case let .dismiss(val):
        state.dismiss = val
        return .none

      case let .onAppear(val):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = val
        let createEnvelopeProperty = state.$createEnvelopeProperty
        let type = state.type
        return .merge(
          .publisher {
            CreateEnvelopeRouterPublisher
              .shared
              .publisher()
              .receive(on: RunLoop.main)
              .map { val in .push(val) }
          },
          .publisher {
            CreateEnvelopeRouterPublisher
              .shared
              .nextPublisher()
              .map { fromState in
                pushWithCrateTypeAndState(type, fromState: fromState, createEnvelopeProperty: createEnvelopeProperty)
                return .none
              }
          },
          .publisher {
            CreateAdditionalRouterPublisher
              .shared
              .publisher()
              .receive(on: RunLoop.main)
              .map { val in .pushAdditionalScreen(val) }
          }
        ).cancellable(id: CancelID.onAppearCancelID, cancelInFlight: true)

      case .header(.tappedDismissButton):
        if state.path.isEmpty {
          return .send(.dismiss(true))
        }
        return .send(.dismissScreen)
          .throttle(
            id: CancelID.dismiss,
            for: .seconds(1),
            scheduler: throttleQueue,
            latest: true
          )

      case .dismissScreen:
        let createType = state.type.toCreateType
        let lastPath = state.path.popLast()
        ssLogEvent(createType, eventName: "뒤로가기 버튼", lastPathState: lastPath, eventType: .tapped)
        return .send(.changeProgress, animation: .easeIn(duration: 0.8))

      case .header:
        return .none

      case let .pushAdditionalScreen(screenType):
        ssLogEvent(state.type.toCreateType, lastPathState: state.path.last, eventType: .none)
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
        return .ssRun { send in
          await send(.pushCreateEnvelopeAdditional, animation: .default)
        }

        // MARK: Additional Section 분기

      case .pushCreateEnvelopeAdditional:
        let createType = state.type
        let lastPath = state.path.last

        // API통신 작업
        guard let currentSection = state.createEnvelopeProperty.additionalSectionHelper.currentSection else {
          ssLogEvent(createType.toCreateType, lastPathState: lastPath, eventType: .none)
          return requestCreateEnvelope()
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
        ssLogEvent(state.type.toCreateType, lastPathState: state.path.last, eventType: .none)
        state.path.append(pathState)
        return .send(.changeProgress)

      case .path:
        return .none

      case .changeProgress:
        let level = state.path.count + 1
        let headerViewProperty: HeaderViewProperty = .init(type: .depthProgressBar(Double(level * 16) / 96))
        return .send(.header(.updateProperty(headerViewProperty)), animation: .easeIn(duration: 0.8))

      case .createPrice:
        return .none

      case let .updateDismissData(data):
        state.currentCreateEnvelopeData = data
        return .none

      case let .isLoading(val):
        state.isLoading = val
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
