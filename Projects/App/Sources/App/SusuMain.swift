import Designsystem
import SwiftUI

@main
struct SusuApp: App {
  @UIApplicationDelegateAdaptor var delegate: MyAppDelegate
  var body: some Scene {
    WindowGroup {
      ContentView(store: .init(initialState: ContentViewFeature.State(headerView: .init(.init(type: .defaultType)))) {
        ContentViewFeature()
      })
    }
  }
}
