import Designsystem
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {}

  public var body: some View {
    VStack {
      
      Text("Hello, susu!")
        .padding()
      
      Color(SSCOlor.blue60)
        .frame(width: 100, height: 100)
        .padding()
    }
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
