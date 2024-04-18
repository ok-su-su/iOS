import ComposableArchitecture
import Designsystem
import Moya
import SSAlert
import SwiftUI
import Moya

// MARK: - ContentView

public struct ContentView: View {
  public init() {}
  @State var name: String = ""
  @State private var showingSheet = false
  @State private var isPresentedValue: Bool = false
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
