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
  @State var sectionTab: SSTabType = .envelope

  public init() {}

  public var body: some View {
    TabView(selection: $sectionTab) {
      Group {
        SentMainView(store: .init(initialState: SentMain.State()) {
          SentMain()
        })
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
    }.toolbar(.hidden, for: .tabBar)

    VStack {
      SSTabbar(selectionType: $sectionTab)
    }.frame(height: 56)
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
  public var body: some View {
    NavigationStack {
      Color(.blue)
        .edgesIgnoringSafeArea(.all)
    }
  }
}
