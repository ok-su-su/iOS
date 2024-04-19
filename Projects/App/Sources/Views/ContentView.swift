import ComposableArchitecture
import Designsystem
import Moya
import OSLog
import Sent
import SSAlert
import SSDataBase
import SSRoot
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  var sectionViews: [SSTabType: AnyView] = [
    .envelope: AnyView(SentMainView(store: .init(initialState: SentMain.State()) {
      SentMain()
    })),
    .inventory: AnyView(InventoryRootView()),
    .vote: AnyView(VoteRootView()),
    .mypage: AnyView(MyPageRootView()),
    .statistics: AnyView(StatisticsRootView()),
  ]

  @Bindable
  var store: StoreOf<ContentViewFeature>

  public var body: some View {
    ZStack {
      VStack(spacing: 0) {
        HeaderView(store: store.scope(state: \.headerView, action: \.headerView))
        Spacer()
          .frame(height: 16)
        contentView()
      }
      .background {
        SSColor.gray15
      }
      .onAppear {
        store.send(.onAppear)
      }
    }
    .safeAreaInset(edge: .bottom) {
      SSTabbar(store: store.scope(state: \.tabBarView, action: \.tabBarView))
        .frame(height: 56)
        .toolbar(.hidden, for: .tabBar)
        .background {
          Color.white
        }
    }
  }

  @ViewBuilder
  func contentView() -> some View {
    sectionViews[store.sectionType]!
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
