import ComposableArchitecture
import Designsystem
import Moya
import OSLog
import SSAlert
import SSDataBase
import SwiftUI
import Moya

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
  ///  let realm = try! Realm()
  public var body: some View {
    VStack {
      Button("HelloSusu") {
        showingSheet.toggle()
      }
      Text("Hello, susu!")
        .padding()
        .foregroundStyle(Color(SSColor.blue50))

  public var body: some View {
    VStack {
      
      Text("Hello, susu!")
        .padding()
        .foregroundStyle(Color(SSColor.blue50))
      
      Color(SSColor.blue100)
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

// MARK: - Todo

//
// class Todo: Object {
//  @Persisted(primaryKey: true) var _id: ObjectId
//  @Persisted var name: String = ""
//  @Persisted var status: String = ""
//  @Persisted var ownerId: String
//  convenience init(name: String, ownerId: String) {
//    self.init()
//    self.name = name
//    self.ownerId = ownerId
//  }
// }
