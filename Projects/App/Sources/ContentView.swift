import ComposableArchitecture
import Designsystem
import SSAlert
import Moya
import OSLog
import SSAlert
import SSDataBase
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {
    TodoSingleTone.shared.save()
    TodoSingleTone.shared.save()
    TodoSingleTone.shared.save()

    TodoSingleTone.shared.load()
  }

  @State var name: String = ""
  @State private var showingSheet = false
  @State private var isPresentedValue: Bool = false
  @State private var mainText = ""
  @State private var ishlighted: Bool = true
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
        MessageAlert(.init(titleText: "asdf", contentText: "asdf", checkBoxMessage: .text("asdf"),
                           buttonMessage: .singleButton("asdf"), didTapCompletionButton: {}),
                     isPresented: $isPresentedValue)
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
      HStack {
        SSTextField(isDisplay: true, text: $mainText, property: .signUp, isHighlight: $ishlighted)
          .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
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
      .init(titleText: "asdf", contentText: "asdf", checkBoxMessage: .text("나는 체크 박스"), buttonMessage: .singleButton("asdf"), didTapCompletionButton: {})
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      SSColor.gray30
    }
  }
}
