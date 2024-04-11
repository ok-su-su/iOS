import Designsystem
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {}

  public var body: some View {
    Text("Hello, susu!")
      .padding()
    Color(DesignSystemColor.systemBlue)
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
