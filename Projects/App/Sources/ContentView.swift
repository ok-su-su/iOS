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
  @State var sectionTab: SSTabType = .envelope

  public init() {}

  public var body: some View {
    TabView(selection: $sectionTab) {
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
    }.toolbar(.hidden, for: .tabBar)

    VStack {
      SSTabbar(selectionType: $sectionTab)
    }.frame(height: 56)
  }
}

// MARK: - EnvelopeRootView

// MARK: 보내요 RootView

public struct EnvelopeRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.systemBackground)
        .ignoresSafeArea()
    }
  }
}

// MARK: - InventoryRootView

// MARK: 받아요 RootView

public struct InventoryRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.blue)
        .edgesIgnoringSafeArea(.all)
    }
  }
}

// MARK: - StatisticsRootView

// MARK: 통계 RootView

public struct StatisticsRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.red)
        .edgesIgnoringSafeArea(.all)
    }
  }
}

// MARK: - VoteRootView

// MARK: 투표 RootView

public struct VoteRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.green)
        .edgesIgnoringSafeArea(.all)
    }
  }
}

// MARK: - MyPageRootView

// MARK: 마이페이지 RootView

public struct MyPageRootView: View {
  public var body: some View {
    NavigationStack {
      Color(.blue)
        .edgesIgnoringSafeArea(.all)
    }
  }
}
