import ComposableArchitecture
import Designsystem
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
  @State private var isPresentedValue: Bool = true
  ///  let realm = try! Realm()
  public var body: some View {
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
