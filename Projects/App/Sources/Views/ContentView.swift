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
  var store: StoreOf<ContentViewFeature>

  public var body: some View {
    VStack {
      HeaderView(store: store.scope(state: \.headerView, action: \.headerView))

      WithViewStore(store, observe: { $0.sectionType }) { _ in
        switch store.sectionType {
        case .envelope:
          EnvelopeRootView()
        case .inventory:
          EnvelopeRootView()
        case .statistics:
          StatisticsRootView()
        case .vote:
          VoteRootView()
        case .mypage:
          MyPageRootView()
        }
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
  }
}
