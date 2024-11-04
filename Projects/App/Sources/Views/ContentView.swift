import Combine
import ComposableArchitecture
import Designsystem
import FirebaseAnalytics
import KakaoLogin
import MyPage
import Onboarding
import OSLog
import Received
import Sent
import SSAlert
import SSFirebase
import SSLaunchScreen
import SSNotification
import SSRoot
import Statistics
import SwiftUI
import Vote

// MARK: - ContentViewObject

final class ContentViewObject: ObservableObject, @unchecked Sendable {
  @Published var nowScreenType: ScreenType = .launchScreen
  @Published var type: SSTabType = .envelope

  func setup() {
    // MARK: EnvelopeView
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedEnveloped, object: nil, queue: .main) { _ in
      ssLogEvent(TabBarEvents.Sent)
      self.type = .envelope
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedInventory, object: nil, queue: .main) { _ in
      ssLogEvent(TabBarEvents.Received)
      self.type = .received
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedStatistics, object: nil, queue: .main) { _ in
      ssLogEvent(TabBarEvents.Statistics)
      self.type = .statistics
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedVote, object: nil, queue: .main) { _ in
      ssLogEvent(TabBarEvents.Vote)
      self.type = .vote
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.tappedMyPage, object: nil, queue: .main) { _ in
      ssLogEvent(TabBarEvents.MyPage)
      self.type = .mypage
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.goMainScene, object: nil, queue: .main) { _ in
      self.nowScreenType = .main
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.logout, object: nil, queue: .main) { _ in
      self.nowScreenType = .loginAndRegister
    }
    NotificationCenter.default.addObserver(forName: SSNotificationName.goMyPageEditMyProfile, object: nil, queue: .main) { _ in
      ssLogEvent(TabBarEvents.MyPage)
      self.type = .mypage
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        NotificationCenter.default.post(name: SSNotificationName.goEditProfile, object: nil)
      }
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
  @ObservedObject
  var contentViewObject: ContentViewObject
  @State
  var isShowDefaultNetworkErrorAlert: Bool = false

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
    .mypage: AnyView(MyPageBuilderView()),
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
            .mypage: AnyView(MyPageBuilderView()),
            .statistics: AnyView(StatisticsBuilderView()),
          ]
          contentViewObject.type = .envelope
        }
      }
      .analyticsScreen(name: contentViewObject.type.title)
      .sSAlert(
        isPresented: $isShowDefaultNetworkErrorAlert,
        messageAlertProperty: .init(
          titleText: "네트워크 에러",
          contentText: "네트워크 오류가 발생했어요",
          checkBoxMessage: .none,
          buttonMessage: .singleButton("닫기"),
          didTapCompletionButton: { _ in }
        )
      )
      .onReceive(NotificationCenter.default.publisher(for: SSNotificationName.showDefaultNetworkErrorAlert)) { _ in
        isShowDefaultNetworkErrorAlert = true
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
