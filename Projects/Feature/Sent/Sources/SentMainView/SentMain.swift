//
//  SentMain.swift
//  Sent
//
//  Created by MaraMincho on 4/19/24.
//  Copyright © 2024 com.susu. All rights reserved.
//

import CommonExtension
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSBottomSelectSheet
import SSCreateEnvelope
import SSFirebase
import SSNotification
import SwiftAsyncMutex

// MARK: - SentMain

@Reducer
struct SentMain: Sendable {
  init() {}

  @ObservableState
  struct State: Sendable {
    // MARK: - Scope

    var header = HeaderViewFeature.State(.init(title: "보내요", type: .defaultType))
    var tabBar = SSTabBarFeature.State(tabbarType: .envelope)
    var isLoading = true
    var isOnAppear = false
    var page: Int = 0
    var isEndOfPage: Bool = false
    var isRefresh = false

    var mutexManager: AsyncMutexManager = .init()
    var presentCreateEnvelope = false
    @Presents var presentDestination: SentMainPresentationDestination.State?
    @Shared var sentMainProperty: SentMainProperty

    var envelopes: IdentifiedArrayOf<Envelope.State> = []

    var isFilteredHeaderButtonItem: Bool {
      return !(sentMainProperty.sentPeopleFilterHelper.selectedPerson.isEmpty && !sentMainProperty.sentPeopleFilterHelper.isFilteredAmount)
    }

    init() {
      _sentMainProperty = Shared(.init())
    }
  }

  enum CancelID {
    case refresh
  }

  @Dependency(\.sentMainNetwork) var network
  @Dependency(\.sentUpdatePublisher) var sentUpdatePublisher
  @Dependency(\.mainQueue) var mainQueue

  enum Action: Equatable, FeatureAction, Sendable {
    case view(ViewAction)
    case inner(InnerAction)
    case async(AsyncAction)
    case scope(ScopeAction)
    case delegate(DelegateAction)
  }

  @CasePathable
  enum ViewAction: Equatable, Sendable {
    case tappedSortButton
    case tappedFilterButton
    case tappedEmptyEnvelopeButton
    case onAppear(Bool)
    case tappedFilteredPersonButton(id: Int64)
    case tappedFilteredAmountButton
    case presentCreateEnvelope(Bool)
    case finishedCreateEnvelopes(Data)
    case tappedFloatingButton
    case pullRefreshButton
  }

  func viewAction(_ state: inout State, _ action: ViewAction) -> Effect<Action> {
    switch action {
    case .tappedSortButton:
      ssLogEvent(.Sent(.main), eventName: "정렬 버튼", eventType: .tapped)
      state.presentDestination = .filterBottomSheet(.init(items: .default, selectedItem: state.$sentMainProperty.selectedFilterDial))
      return .none

    case .tappedFilterButton:
      ssLogEvent(.Sent(.main), eventName: "필터 버튼", eventType: .tapped)
      state.presentDestination = .filter(.init(filterHelper: state.$sentMainProperty.sentPeopleFilterHelper))
      return .none

    case .tappedEmptyEnvelopeButton:
      return .send(.inner(.showCreateEnvelopRouter))

    case let .onAppear(appear):
      if state.isOnAppear {
        return .none
      }
      state.isOnAppear = appear
      return .merge(
        .send(.async(.updateEnvelopesByFilter)),
        sinkSentUpdatePublisher()
      )

    case let .tappedFilteredPersonButton(id):
      state.sentMainProperty.sentPeopleFilterHelper.select(selectedId: id)
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case .tappedFilteredAmountButton:
      state.sentMainProperty.sentPeopleFilterHelper.deselectAmount()
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case let .presentCreateEnvelope(present):
      state.presentCreateEnvelope = present
      return .none

    case .finishedCreateEnvelopes:
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    // create Envelope
    case .tappedFloatingButton:
      ssLogEvent(SentEvents.tappedCreateEnvelope)
      return .send(.inner(.showCreateEnvelopRouter))

    case .pullRefreshButton:
      return .concatenate(
        .send(.async(.updateEnvelopesByFilterInitialPage))
      )
      .cancellable(id: CancelID.refresh, cancelInFlight: true)
    }
  }

  @CasePathable
  enum InnerAction: Equatable, Sendable {
    case showCreateEnvelopRouter
    case updateEnvelopes([EnvelopeProperty])
    case overwriteEnvelopes([EnvelopeProperty])
    case isLoading(Bool)
    case isRefresh(Bool)
    case deleteEnvelopes(friendID: Int64)
  }

  func innerAction(_ state: inout State, _ action: InnerAction) -> Effect<Action> {
    switch action {
    case .showCreateEnvelopRouter:
      state.presentCreateEnvelope = true
      return .none

    case let .updateEnvelopes(val):
      let prevEnvelopesCount = state.envelopes.count
      let currentEnvelopeProperty = (state.envelopes.map(\.envelopeProperty) + val).uniqued()
      let uniqueElement = currentEnvelopeProperty.map { Envelope.State(envelopeProperty: $0) }
      if prevEnvelopesCount == state.envelopes.count || val.count % 30 != 0 {
        state.isEndOfPage = true
      }
      state.envelopes = .init(uniqueElements: uniqueElement)
      return .none

    case let .isLoading(val):
      state.isLoading = val
      return .none

    case let .isRefresh(val):
      state.isRefresh = val
      return .none

    case let .deleteEnvelopes(friendID):
      state.envelopes = state.envelopes.filter { $0.envelopeProperty.id != friendID }
      return .none

    case let .overwriteEnvelopes(envelopes):
      envelopes.forEach { property in
        if let envelopeID = state.envelopes.first(where: { $0.envelopeProperty.id == property.id })?.id {
          state.envelopes[id: envelopeID]?.envelopeProperty = property
        }
      }
      return .none
    }
  }

  @CasePathable
  enum AsyncAction: Equatable, Sendable {
    case updateEnvelopesByFilter
    case updateEnvelopesByFilterInitialPage
    case updateEnvelopes(friendID: Int64)
  }

  func asyncAction(_ state: inout State, _ action: AsyncAction) -> Effect<Action> {
    switch action {
    case .updateEnvelopesByFilter:
      let page = state.page
      state.page += 1
      let urlParameter = SearchFriendsParameter(
        friendIds: state.sentMainProperty.sentPeopleFilterHelper.selectedPerson.map(\.id),
        fromTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.lowestAmount,
        toTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.highestAmount,
        page: page,
        sort: state.sentMainProperty.selectedFilterDial ?? .highestAmount
      )
      return .ssRun { send in
        await send(.inner(.isLoading(true)))
        let envelopeProperties = try await network.requestSearchFriends(urlParameter)
        await send(.inner(.updateEnvelopes(envelopeProperties)))
        await send(.inner(.isLoading(false)))
      }

    case .updateEnvelopesByFilterInitialPage:
      state.page = 1
      state.isEndOfPage = false
      let currentState = state.sentMainProperty.selectedFilterDial?.sortString
      os_log("current Selected Section \(currentState ?? "nil")")
      state.envelopes = .init(uniqueElements: [])
      let urlParameter = SearchFriendsParameter(
        friendIds: state.sentMainProperty.sentPeopleFilterHelper.selectedPerson.map(\.id),
        fromTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.lowestAmount,
        toTotalAmounts: state.sentMainProperty.sentPeopleFilterHelper.highestAmount,
        page: 0,
        sort: state.sentMainProperty.selectedFilterDial ?? .latest
      )

      // isLoading
      state.isLoading = true
      return .runWithTCAMutex(state.mutexManager) { send in
        let envelopeProperties = try await network.requestSearchFriends(urlParameter)
        await send(.inner(.updateEnvelopes(envelopeProperties)))
      } endOperation: { send in
        await send(.inner(.isLoading(false)))
      }

    case let .updateEnvelopes(friendID):
      let urlParameter = SearchFriendsParameter(friendIds: [friendID])
      let targetEnvelopeID = state.envelopes.first(where: { $0.envelopeProperty.id == friendID })?.id
      return .ssRun { send in
        await send(.inner(.isLoading(true)))
        let envelopeProperties = try await network.requestSearchFriends(urlParameter)
        await send(.inner(.overwriteEnvelopes(envelopeProperties)))
        if let targetEnvelopeID {
          await send(.scope(.envelopes(.element(id: targetEnvelopeID, action: .getEnvelopeDetail))))
        }
        await send(.inner(.isLoading(false)))
      }
    }
  }

  @CasePathable
  enum ScopeAction: Equatable, Sendable {
    case header(HeaderViewFeature.Action)
    case tabBar(SSTabBarFeature.Action)

    case envelopes(IdentifiedActionOf<Envelope>)
    case presentDestination(PresentationAction<SentMainPresentationDestination.Action>)
  }

  func scopeAction(_ state: inout State, _ action: ScopeAction) -> Effect<Action> {
    switch action {
    case let .envelopes(.element(id: _, action: .pushEnvelopeDetail(property))):
      state.presentDestination = .specificEnvelope(.init(envelopeProperty: property))
      return .none

    case .header(.tappedSearchButton):
      state.presentDestination = .searchEnvelope(.init())
      return .none

    case .presentDestination(.presented(.filterBottomSheet(.tapped))):
      let description = "정렬" + (state.sentMainProperty.selectedFilterDial?.description ?? "") + "버튼"
      ssLogEvent(.Sent(.main), eventName: description, eventType: .tapped)

      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case .presentDestination(.presented(.filter(.tappedConfirmButton))):
      ssLogEvent(.Sent(.main), eventName: "필터 적용 버튼", eventType: .tapped)
      return .send(.async(.updateEnvelopesByFilterInitialPage))

    case let .envelopes(.element(id: uuid, action: .isOnAppear(true))):
      if state.envelopes.last?.id == uuid && !state.isEndOfPage {
        let isEndOfPage = state.isEndOfPage.description
        os_log("페이지를 요청합니다., \(isEndOfPage)")
        return .send(.async(.updateEnvelopesByFilter))
          .throttle(id: ThrottleID.getFriendThrottleID, for: 2, scheduler: mainQueue, latest: false)
      }
      return .none

    case .tabBar:
      return .none

    default:
      return .none
    }
  }

  enum DelegateAction: Equatable, Sendable {
    case pushFilter
  }

  private enum ThrottleID {
    case getFriendThrottleID
  }

  var body: some Reducer<State, Action> {
    // MARK: - Scope Child Reducers

    Scope(state: \.header, action: \.scope.header) {
      HeaderViewFeature()
    }
    Scope(state: \.tabBar, action: \.scope.tabBar) {
      SSTabBarFeature()
    }

    // MARK: - Reducer

    Reduce { state, action in
      switch action {
      case let .view(currentAction):
        return viewAction(&state, currentAction)
      case let .inner(currentAction):
        return innerAction(&state, currentAction)
      case let .async(currentAction):
        return asyncAction(&state, currentAction)
      case let .scope(currentAction):
        return scopeAction(&state, currentAction)

      case .delegate:
        return .none
      }
    }
    .subFeatures1()
  }
}

private extension Reducer where State == SentMain.State, Action == SentMain.Action {
  func subFeatures1() -> some ReducerOf<Self> {
    ifLet(\.$presentDestination, action: \.scope.presentDestination)
      .forEach(\.envelopes, action: \.scope.envelopes) {
        Envelope()
      }
  }
}

// MARK: - FilterDialItem

enum FilterDialItem: Int, SSSelectBottomSheetPropertyItemable {
  case latest = 0
  case oldest
  case highestAmount
  case lowestAmount

  var description: String {
    switch self {
    case .latest:
      "최신순"
    case .oldest:
      "오래된순"
    case .highestAmount:
      "금액 높은 순"
    case .lowestAmount:
      "금액 낮은 순"
    }
  }

  var id: Int { rawValue }

  var sortString: String {
    switch self {
    case .latest:
      "handedOverAt,desc"
    case .oldest:
      "handedOverAt,asc"
    case .highestAmount:
      "amount,desc"
    case .lowestAmount:
      "amount,asc"
    }
  }
}

extension [FilterDialItem] {
  static var `default`: Self {
    return [
      .latest,
      .oldest,
      .highestAmount,
      .lowestAmount,
    ]
  }

  static var initialValue: FilterDialItem {
    .latest
  }
}

// MARK: - SentMain + FeatureViewAction, FeatureAsyncAction, FeatureInnerAction, FeatureScopeAction

extension SentMain: FeatureViewAction, FeatureAsyncAction, FeatureInnerAction, FeatureScopeAction {
  func sinkSentUpdatePublisher() -> Effect<Action> {
    return .merge(
      .publisher {
        sentUpdatePublisher
          .deleteFriendPublisher
          .receive(on: RunLoop.main)
          .map { friendID in return .inner(.deleteEnvelopes(friendID: friendID)) }
      },
      .publisher {
        sentUpdatePublisher
          .editedFriendPublisher
          .receive(on: RunLoop.main)
          .map { friendID in return .async(.updateEnvelopes(friendID: friendID)) }
      },
      .publisher {
        sentUpdatePublisher
          .updatePublisher
          .receive(on: RunLoop.main)
          .map { _ in return .async(.updateEnvelopesByFilterInitialPage) }
      }
    )
  }
}
