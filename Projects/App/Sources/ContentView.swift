import ComposableArchitecture
import Designsystem
import Moya
import OSLog
import RealmSwift
import SSAlert
import SwiftUI

// MARK: - ContentView

public struct ContentView: View {
  public init() {
//    let todo = Todo(name: "Do laundry", ownerId: "123")
//    try! realm.write {
//      realm.add(todo)
//      realm.add(todo)
//    }
//    let todos = realm.objects(Todo.self)
//    os_log("\(todos)")
  }

  @State var name: String = ""
  @State private var showingSheet = false
  @State private var isPresentedValue: Bool = false
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
      .init(titleText: "asdf", contentText: "asdf", checkBoxMessage: .none, buttonMessage: .singleButton("asdf"), didTapCompletionButton: {})
    )
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


// MARK: - Todo

 class Todo: Object {
  @Persisted(primaryKey: true) var _id: ObjectId
  @Persisted var name: String = ""
  @Persisted var status: String = ""
  @Persisted var ownerId: String
  convenience init(name: String, ownerId: String) {
    self.init()
    self.name = name
    self.ownerId = ownerId
  }
 }
