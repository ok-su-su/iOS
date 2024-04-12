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

      HStack {
        SSButton(.init(size: .lh46, status: .active, style: .filled, color: .black, buttonText: "Button"), onTap: {})
        SSButton(
          .init(
            size: .lh54, status: .active, style: .filled, color: .black,
            leftIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            rightIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            buttonText: "Button"
          ), onTap: {}
        )

        SSButton(
          .init(
            size: .lh54, status: .active, style: .lined, color: .black,
            leftIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            rightIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            buttonText: "Button"
          ), onTap: {}
        )
      }

      HStack {
        SSButton(.init(size: .lh46, status: .inactive, style: .filled, color: .orange, buttonText: "Button"), onTap: {})
        SSButton(
          .init(
            size: .lh54, status: .active, style: .filled, color: .orange,
            leftIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            rightIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            buttonText: "Button"
          ), onTap: {}
        )

        SSButton(
          .init(
            size: .lh54, status: .active, style: .lined, color: .orange,
            leftIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            rightIcon: .icon(.init(uiImage: SSImage.voteMainFill)),
            buttonText: "Button"
          ), onTap: {}
        )
      }

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
