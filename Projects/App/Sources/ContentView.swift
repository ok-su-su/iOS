import Designsystem
import SSAlert
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {}
  @State var name: String = ""
  @State private var showingSheet = false
  @State private var isPresentedValue: Bool = false
  public var body: some View {
    Text("Hello, susu!")
      .padding()
    //TODO: Delete plz...
    Color(DesignSystemColor.systemBlue)
    VStack {
      Button("HelloSusu") {
        showingSheet.toggle()
      }
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
            size: .lh54, status: .inactive, style: .lined, color: .black,
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
            size: .lh46, status: .inactive, style: .lined, color: .orange,
            buttonText: "tton"
          ), onTap: {}
        )
      }

      Color(SSColor.gray15)
        .frame(width: 100, height: 100)
        .padding()

      Image(uiImage: SSImage.commonLogo)
        .frame(width: 400, height: 400, alignment: .center)
    }
    .customAlert(
      isPresented: $showingSheet,
      messageAlertProperty:
          .init(titleText: "asdf", contentText: "asdf", checkBoxMessage: .none, buttonMessage: .singleButton("asdf"), didTapCompletionButton: {}))
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      SSColor.gray30
    }
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
