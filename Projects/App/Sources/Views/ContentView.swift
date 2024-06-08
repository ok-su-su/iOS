import ComposableArchitecture
import Designsystem
import Inventory
import KakaoLogin
import MyPage
import OSLog
import Sent
import SSAlert
import SSRoot
import Statistics
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
    .inventory: AnyView(InventoryBuilderView()),
    .vote: AnyView(VoteBuilder()),
    .mypage: AnyView(ProfileNavigationView().ignoresSafeArea()),
    .statistics: AnyView(StatisticsBuilderView()),
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
