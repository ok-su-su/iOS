import ComposableArchitecture
import Designsystem
import Moya
import OSLog
import Sent
import SSAlert
import SSDataBase
import SSRoot
import SwiftUI

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
    .envelope: AnyView(SentMainView(store: .init(initialState: SentMain.State()) {
      SentMain()
    })),
    .inventory: AnyView(InventoryView(inventoryStore: .init(initialState: InventoryViewFeature.State(inventorys: [])) {
        InventoryViewFeature()
    })),
    .vote: AnyView(VoteRootView()),
    .mypage: AnyView(MyPageRootView()),
    .statistics: AnyView(StatisticsRootView()),
  ]

  public var body: some View {
    ZStack {
      SSColor
        .gray15
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

// MARK: - MyPageRootView

public struct MyPageRootView: View {
  init() {
    os_log("마이 페이지가 나타났어!")
  }

  public var body: some View {
    NavigationStack {
      Color(.blue)
        .edgesIgnoringSafeArea(.all)
    }
    .onAppear {
      os_log("mypage view was appear")
    }
  }
}
