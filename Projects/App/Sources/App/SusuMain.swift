import Designsystem
import KakaoLogin
import SwiftUI

// MARK: - SusuApp

@main
struct SusuApp: App {
  init() {
    #if DEBUG
      UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    #endif
    LoginWithKakao.initKakaoSDK()
  }

  @UIApplicationDelegateAdaptor var delegate: MyAppDelegate
  var body: some Scene {
    WindowGroup {
      ContentView(contentViewObject: .init())
    }
  }
}
