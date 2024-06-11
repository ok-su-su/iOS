import Designsystem
import KakaoLogin
import SwiftUI

@main
struct SusuApp: App {
  init() {
    LoginWithKakao.initKakaoSDK()
  }

  @UIApplicationDelegateAdaptor var delegate: MyAppDelegate
  var body: some Scene {
    WindowGroup {
      ContentView(contentViewObject: .init())
    }
  }
}
