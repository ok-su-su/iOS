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
    Button("Show Sheet") {
      showingSheet.toggle()
    }
    VStack {
      MessageAlert(
        .init(
          titleText: "모달명 제목", contentText: "텍스트 메세지를 입력하세요",
          checkBoxMessage: .text("체크박스 메세지"),
          buttonMessage: .doubleButton(left: "닫기", right: "버튼명")
        ),
        isPresented: $isPresentedValue
      )

      MessageAlert(
        .init(
          titleText: "모달명 제목", contentText: "텍스트 메세지를 입력하세요",
          checkBoxMessage: .text("체크박스 메세지"),
          buttonMessage: .singleButton("확인했어요")
        ),
        isPresented: $isPresentedValue
      )
    }
    .customAlert(isPresented: $showingSheet)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      Color.blue
    }
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
