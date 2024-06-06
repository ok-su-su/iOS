import Combine
import ComposableArchitecture
import Designsystem
import Inventory
import MyPage
import Onboarding
import Sent
import SSAlert
import SSLaunchScreen
import SSRoot
import Statistics
import SwiftUI
import Vote

// MARK: - ContentViewObject

final class ContentViewObject: ObservableObject {
  @Published var nowScreenType: ScreenType = .launchScreen
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

// MARK: - ScreenType

enum ScreenType {
  case launchScreen
  case loginAndRegister
  case main
}

// MARK: - ContentView

public struct ContentView: View {
  @ObservedObject var contentViewObject: ContentViewObject

  private var subscriptions: Set<AnyCancellable> = .init()

  init(contentViewObject: ContentViewObject) {
    self.contentViewObject = contentViewObject
    bind()
  }

  private mutating func bind() {
    SSLaunchScreenBuilderRouterPublisher.shared
      .publisher()
      .subscribe(on: RunLoop.main)
      .sink { [self] status in
        switch status {
        case .launchTaskWillRun:
          break
        case let .launchTaskDidRun(endedLaunchScreenStatus):
          switch endedLaunchScreenStatus {
          case .newUser:
            contentViewObject.nowScreenType = .loginAndRegister
          case .prevUser:
            contentViewObject.nowScreenType = .main
          }
        }
        return
      }
      .store(in: &subscriptions)
  }

  var sectionViews: [SSTabType: AnyView] = [
    .envelope: AnyView(SentBuilderView()),
    .inventory: AnyView(InventoryBuilderView()),
    .vote: AnyView(VoteBuilder()),
    .mypage: AnyView(ProfileNavigationView().ignoresSafeArea()),
    .statistics: AnyView(StatisticsBuilderView()),
  ]

  public var body: some View {
    VStack(spacing: 0) {
      contentView()
    }
    .onAppear {}
  }

  @ViewBuilder
  func contentView() -> some View {
    switch contentViewObject.nowScreenType {
    case .launchScreen:
      SSLaunchScreenBuilderView()
    case .loginAndRegister:
      OnboardingBuilderView()
    case .main:
      sectionViews[contentViewObject.type]!
    }
  }
}
