import Combine
import ComposableArchitecture
import Designsystem
import KakaoLogin
import MyPage
import Onboarding
import OSLog
import Received
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
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedEnveloped, object: nil, queue: .main) { _ in
      self.type = .envelope
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedInventory, object: nil, queue: .main) { _ in
      self.type = .received
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedStatistics, object: nil, queue: .main) { _ in
      self.type = .statistics
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedVote, object: nil, queue: .main) { _ in
      self.type = .vote
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedMyPage, object: nil, queue: .main) { _ in
      self.type = .mypage
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.goMainScene, object: nil, queue: .main) { _ in
      self.nowScreenType = .main
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.logout, object: nil, queue: .main) { _ in
      self.nowScreenType = .loginAndRegister
    }
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
    // LaunchScreenPublisher
    SSLaunchScreenBuilderRouterPublisher.shared
      .publisher()
      .receive(on: RunLoop.main)
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

  @State var sectionViews: [SSTabType: AnyView] = [
    .envelope: AnyView(SentBuilderView()),
    .received: AnyView(ReceivedBuilderView()),
    .vote: AnyView(VoteBuilder()),
    .mypage: AnyView(ProfileNavigationView().ignoresSafeArea()),
    .statistics: AnyView(StatisticsBuilderView()),
  ]

  public var body: some View {
    contentView()
      .onChange(of: contentViewObject.nowScreenType) { oldValue, newValue in
        if oldValue == .loginAndRegister, newValue == .main {
          sectionViews = [
            .envelope: AnyView(SentBuilderView()),
            .received: AnyView(ReceivedBuilderView()),
            .vote: AnyView(VoteBuilder()),
            .mypage: AnyView(ProfileNavigationView().ignoresSafeArea()),
            .statistics: AnyView(StatisticsBuilderView()),
          ]
          contentViewObject.type = .envelope
        }
      }
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
