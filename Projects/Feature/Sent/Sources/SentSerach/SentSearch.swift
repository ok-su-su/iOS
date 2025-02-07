//
//  SentSearch.swift
//  Sent
//
//  Created by MaraMincho on 6/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import CommonExtension
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSRegexManager
import SSSearch

// MARK: - SentSearch

@Reducer
struct SentSearch: Sendable {
  @ObservableState
  struct State: Equatable, Sendable {
    var isOnAppear = false
    var path: StackState<SpecificEnvelopeHistoryRouterPath.State> = .init()
    @Shared var property: SentSearchProperty
    var search: SSSearchReducer<SentSearchProperty>.State
    var header: HeaderViewFeature.State = .init(.init(type: .depth2Default))
    init() {
      _property = .init(.default())
      search = .init(helper: _property)
    }
  }

  @Dependency(\.sentSearchNetwork) var network
  @Dependency(\.sentSearchPersistence) var persistence

  enum Action: Equatable, Sendable {
    case onAppear(Bool)
    case search(SSSearchReducer<SentSearchProperty>.Action)
    case path(StackActionOf<SpecificEnvelopeHistoryRouterPath>)
    case push(SpecificEnvelopeHistoryRouterPath.State)
    case header(HeaderViewFeature.Action)
    case searchEnvelope
    case updateSearchResult([SentSearchItem])
    case updatePrevSearchedItems
  }

  enum DelegateAction: Equatable {}

  enum ThrottleID {
    case searchThrottleID
  }

  @Dependency(\.mainQueue) var mainQueue
  func searchAction(state: inout State, action: SSSearchReducer<SentSearchProperty>.Action) -> Effect<Action> {
    switch action {
    case let .changeTextField(textFieldText):
      if RegexManager.isValidName(textFieldText) || Int64(textFieldText) != nil {
        return .send(.searchEnvelope)
          .throttle(id: ThrottleID.searchThrottleID, for: .seconds(0.5), scheduler: mainQueue, latest: true)
      }
      return .none

    case let .tappedPrevItem(id: id):
      guard let currentPrevItem = state.property.prevSearchedItem.first(where: { $0.id == id }) else {
        return .none
      }
      return .send(.search(.changeTextField(currentPrevItem.title)))

    case let .tappedDeletePrevItem(id: id):
      persistence.deleteSearchItem(id: id)
      state.property.prevSearchedItem = persistence.getPrevSentSearchItems()
      return .none
    case let .tappedSearchItem(id: id):
      let searchedItem = state.property.nowSearchedItem.first(where: { $0.id == id })
      return .ssRun { _ in
        // 만약 id검색에 성공한다면 화면 푸쉬를 진행합니다.
        guard let envelopeProperty = try await network.getEnvelopePropertyByID(id) else {
          return
        }
        persistence.setSearchItems(searchedItem)
        SpecificEnvelopeHistoryRouterPublisher
          .push(.specificEnvelopeHistoryList(.init(envelopeProperty: envelopeProperty)))
      }
    default:
      return .none
    }
  }

  var body: some Reducer<State, Action> {
    Scope(state: \.header, action: \.header) {
      HeaderViewFeature()
    }
    Scope(state: \.search, action: \.search) {
      SSSearchReducer()
    }

    Reduce { state, action in
      switch action {
      case let .onAppear(isAppear):
        if state.isOnAppear {
          return .none
        }
        state.isOnAppear = isAppear
        return .merge(
          .publisher {
            SpecificEnvelopeHistoryRouterPublisher.publisher
              .receive(on: RunLoop.main)
              .map { .push($0) }
          },
          .send(.updatePrevSearchedItems)
        )
      case .path:
        return .none

      // MARK: - Search Action

      case let .search(currentAction):
        return searchAction(state: &state, action: currentAction)

      case let .push(pathState):
        state.path.append(pathState)
        return .none

      case .header:
        return .none

      case .searchEnvelope:
        let currentTextFieldName = state.property.textFieldText
        return .ssRun { send in
          async let searchedEnvelopes = network.searchFriendsByName(currentTextFieldName)
          let amount = Int64(currentTextFieldName)
          async let searchedEnvelopesByAmount = amount != nil ? network.requestSearchFriendsByAmount(amount!) : []
          let envelopesItem = try await (searchedEnvelopes + searchedEnvelopesByAmount)
          await send(.updateSearchResult(envelopesItem.uniqued()))
        }

      case let .updateSearchResult(results):
        state.property.nowSearchedItem = results
        return .none

      case .updatePrevSearchedItems:
        state.property.prevSearchedItem = persistence.getPrevSentSearchItems()
        return .none
      }
    }
    .addFeatures()
  }
}

extension Reducer where State == SentSearch.State, Action == SentSearch.Action {
  func addFeatures() -> some ReducerOf<Self> {
    forEach(\.path, action: \.path)
  }
}
