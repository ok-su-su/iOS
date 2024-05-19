import Designsystem
import SwiftUI

@main
struct ToastPreviewMain: App {
  var body: some Scene {
    WindowGroup {
      ContentView(store: .init(initialState: ContentReducer.State(), reducer: {
        ContentReducer()
      }))
    }
  }
}


