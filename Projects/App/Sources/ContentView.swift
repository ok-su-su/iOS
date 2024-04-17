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
  public init() {}

  public var body: some View {
    RootView(store: Store(initialState: RootViewFeature.State()) {
      RootViewFeature()
    })
  }
}
