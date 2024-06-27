//
//  SentSearch.swift
//  Sent
//
//  Created by MaraMincho on 6/26/24.
//  Copyright © 2024 com.oksusu. All rights reserved.
//
import ComposableArchitecture
import Designsystem
import FeatureAction
import Foundation
import OSLog
import SSSearch

// MARK: - SentSearch

@Reducer
struct SentSearch {
  @ObservableState
  struct State: Equatable {
    var isOnAppear = false
    var path: StackState<SpecificEnvelopeHistoryRouterPath.State> = .init()
    @Shared var property: SentSearchProperty
    var search: SSSearchReducer<SentSearchProperty>.State
    var header: HeaderViewFeature.State = .init(.init(type: .depth2Default))
    init() {
      _property = .init(
        .init(
          prevSearchedItem: [
            SentSearchItem(id: 0, title: "dddd", firstContentDescription: "asdf", secondContentDescription: "aswssws"),
          ],
          nowSearchedItem: [
          ],
          textFieldPromptText: "찾고 싶은 봉투를 검색해보세요",
          prevSearchedNoContentTitleText: "어떤 투표를 찾아드릴까요?",
          prevSearchedNoContentDescriptionText: "궁금하신 것들의 키워드를\n검색해볼 수 있어요",
          textFieldText: "",
          iconType: .sent,
          noSearchResultTitle: "원하는 검색 결과가 없나요?",
          noSearchResultDescription: "사람 이름, 보낸 금액, 경조사 명 등을\n검색해볼 수 있어요"
        )
      )
      search = .init(helper: _property)
    }
  }

  @Dependency(\.sentSearchNetwork) var network
  @Dependency(\.sentSearchPersistence) var persistence

  enum Action: Equatable {
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
              .map { .push($0) }
          },
          .send(.updatePrevSearchedItems)
        )
      case .path:
        return .none

      // MARK: - Search Action

      case let .search(action):
        switch action {
        case let .changeTextField(textFieldText):
          if NameRegexManager.isValid(name: textFieldText) || Int64(textFieldText) != nil {
            return .send(.searchEnvelope)
              .throttle(id: ThrottleID.searchThrottleID, for: .seconds(2), scheduler: RunLoop.main, latest: true)
          }
          return .none
        case let .tappedPrevItem(id: id):
          // 과거 검색 기록 아이템을 클릭 했을 때 로직 추가
          return .none
        case let .tappedDeletePrevItem(id: id):
          // 과거 검색 기록을 삭제하는 로직 추가
          return .none
        case let .tappedSearchItem(id: id):
          // 검색 결과를 클릭했을 때 움직이는 로직 추가
          return .none
        default:
          return .none
        }
      case let .push(pathState):
        state.path.append(pathState)
        return .none

      case .header:
        return .none

      case .searchEnvelope:
        let currentTextFieldText = state.property.textFieldText
        return .run { send in
          os_log("검색 시작합니다. \(currentTextFieldText)")
          // 이름을 통해 검색
          var searchedEnvelopes = try await network.searchFriendsBy(name: currentTextFieldText)
          // 금액을 통해 검색
          if let amount = Int(currentTextFieldText) {
            searchedEnvelopes += try await network.searchEnvelopeBy(amount: amount)
          }
          await send(.updateSearchResult(searchedEnvelopes.uniqued()))
        }

      case let .updateSearchResult(results):
        let count = state.property.nowSearchedItem.count
        let text = state.property.textFieldText
        os_log("검색 결과 카운트 = \(count), text = \(text)")
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

// MARK: - SentSearchProperty

struct SentSearchProperty: SSSearchPropertiable {
  typealias item = SentSearchItem
  var prevSearchedItem: [item]
  var nowSearchedItem: [item]
  var textFieldPromptText: String
  var prevSearchedNoContentTitleText: String
  var prevSearchedNoContentDescriptionText: String
  var textFieldText: String
  var iconType: SSSearchIconType
  var noSearchResultTitle: String
  var noSearchResultDescription: String
  mutating func searchItem(by _: String) {}

  mutating func deletePrevItem(prevItemID _: Int64) {}
}

// MARK: - SentSearchItem

struct SentSearchItem: SSSearchItemable, Hashable {
  /// 친구의 아이디 입니다.
  var id: Int64
  /// 친구의 이름 입니다.
  var title: String
  /// 경조사 이름 입니다.
  var firstContentDescription: String?
  /// 날짜 이름 입니다.
  var secondContentDescription: String?
}
