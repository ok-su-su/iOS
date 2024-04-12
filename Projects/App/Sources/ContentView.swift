import Designsystem
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {}
  @State var name: String = ""

  public var body: some View {
    VStack {
      
      Text("Hello, susu!")
        .padding()
        .foregroundStyle(Color(SSColor.blue50))
      
      Color(SSColor.blue100)
        .frame(width: 100, height: 100)
        .padding()
      
      Image(uiImage: SSImage.commonLogo)
        .frame(width: 400, height: 400, alignment: .center)
    }
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
