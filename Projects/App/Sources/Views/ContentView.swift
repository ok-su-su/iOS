import ComposableArchitecture
import Designsystem
import Inventory
import MyPage
import Sent
import SSRoot
import SwiftUI
import Vote

// MARK: - ContentViewObject

final class ContentViewObject: ObservableObject {
  @Published var type: SSTabType = .envelope

  func setup() {
    NotificationCenter.default.addObserver(self, selector: #selector(enveloped), name: SSNotificationName.tappedEnveloped, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(inventory), name: SSNotificationName.tappedInventory, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(statics), name: SSNotificationName.tappedStatistics, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(vote), name: SSNotificationName.tappedVote, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(myPage), name: SSNotificationName.tappedMyPage, object: nil)
  }

  @objc func enveloped() {
    type = .envelope
  }

  @objc func inventory() {
    type = .inventory
  }

  @objc func statics() {
    type = .statistics
  }

  @objc func vote() {
    type = .vote
  }

  @objc func myPage() {
    type = .mypage
  }

  init() {
    setup()
  }
}

// MARK: - ContentView

public struct ContentView: View {
  @ObservedObject var ContentViewObject: ContentViewObject

  var sectionViews: [SSTabType: AnyView] = [
    .envelope: AnyView(SentBuilderView()),
    .inventory: AnyView(InventoryView(
      inventoryStore:
      .init(
        initialState: InventoryViewFeature.State(
          inventorys: [
            .init(inventoryType: .Wedding, inventoryTitle: "123", inventoryAmount: "123", inventoryCount: 1),
            .init(inventoryType: .Wedding, inventoryTitle: "123", inventoryAmount: "123", inventoryCount: 1),
          ]
        )
      ) {
        InventoryViewFeature()
      })),
    .vote: AnyView(VoteBuilder()),
    .mypage: AnyView(ProfileNavigationView().ignoresSafeArea()),
    .statistics: AnyView(StatisticsRootView()),
  ]

  public var body: some View {
    ZStack {
      SSColor
        .gray90
        .ignoresSafeArea()
      VStack(spacing: 0) {
        contentView()
      }
      .onAppear {}
    }
  }

  @ViewBuilder
  func contentView() -> some View {
    sectionViews[ContentViewObject.type]!
  }
}

// MARK: - EnvelopeRootView

public struct EnvelopeRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.systemBackground)
        .ignoresSafeArea()
    }
  }
}

// MARK: - InventoryRootView

public struct InventoryRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.blue)
        .edgesIgnoringSafeArea(.all)
    }
  }
}

// MARK: - StatisticsRootView

public struct StatisticsRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.red)
        .edgesIgnoringSafeArea(.all)
    }
  }
}

// MARK: - VoteRootView

public struct VoteRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.green)
        .edgesIgnoringSafeArea(.all)
    }
  }
}
