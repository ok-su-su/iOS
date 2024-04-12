import Designsystem
import SSAlert
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {}
  @State var name: String = ""

  public var body: some View {
    VStack {
      MessageAlert(titleText: "dd", contentText: "하이용")
      Text("Hello, susu!")
        .padding()

//      Color(SSColor.blue100)
//        .frame(width: 100, height: 100)
//        .padding()

      Image(uiImage: SSImage.commonLogo)
        .frame(width: 400, height: 400, alignment: .center)
    }
    .background {
      SSColor.blue20
    }
    .frame(maxHeight: .infinity)
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
