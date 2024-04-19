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
  @Bindable
  var store: StoreOf<ContentViewFeature>

  public var body: some View {
    VStack {
      WithViewStore(store, observe: { $0.headerView }) { _ in
        HeaderView(store: store.scope(state: \.headerView, action: \.headerView))
      }
      
      WithViewStore(store, observe: { $0.sectionType }) { _ in
        TabView(selection: $store.sectionType.sending(\.tapSectionButton)) {
          Group {
            EnvelopeRootView()
              .tag(SSTabType.envelope)

            InventoryRootView()
              .tag(SSTabType.inventory)

            StatisticsRootView()
              .tag(SSTabType.statistics)

            VoteRootView()
              .tag(SSTabType.vote)

            MyPageRootView()
              .tag(SSTabType.mypage)
          }
        }
      }
      .toolbar(.hidden, for: .tabBar)
      .onAppear {
        store.send(.onAppear)
      }

      VStack {
        SSTabbar(selectionType: $store.sectionType.sending(\.tapSectionButton))
      }.frame(height: 56)
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
