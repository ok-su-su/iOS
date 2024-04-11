import Designsystem
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {}

  public var body: some View {
    VStack {
      DesignSystemText(text: "Hello, susu!", designSystemFont: .title_xs)
      // TODO: Delete plz...
      Text("Hello, susu!")
        .font(.custom("asdf", size: 46))
        .padding()
      // TODO: Delete plz...
    }
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
