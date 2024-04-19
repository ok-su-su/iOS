import ComposableArchitecture
import Designsystem
import Moya
import OSLog
import SSAlert
import SSDataBase
import SSRoot
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  var sectionViews: [SSTabType: AnyView] = [
    .envelope: AnyView(EnvelopeRootView()),
    .inventory: AnyView(InventoryRootView()),
    .vote: AnyView(VoteRootView()),
    .mypage: AnyView(MyPageRootView()),
    .statistics: AnyView(StatisticsRootView()),
  ]
  @Bindable
  var store: StoreOf<ContentViewFeature>

  public var body: some View {
    VStack {
      HeaderView(store: store.scope(state: \.headerView, action: \.headerView))
      WithViewStore(store, observe: { $0.sectionType }) { _ in
        contentView()
      }
      VStack {
        SSTabbar(store: store.scope(state: \.tabbarView, action: \.tabbarView))
      }
      .frame(height: 56)
      .toolbar(.hidden, for: .tabBar)
    }
    .onAppear {
      store.send(.onAppear)
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
  init() {
    os_log("iam inited")
  }

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
