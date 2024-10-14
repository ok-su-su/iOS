import Designsystem
import KakaoLogin
import SSNotification
import SwiftUI

// MARK: - SusuApp

@main
struct SusuApp: App {
  @State private var contentViewID: UUID = .init()
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
        .onReceive(NotificationCenter.default.publisher(for: SSNotificationName.resetApp)) { _ in
          contentViewID = .init()
        }
        .id(contentViewID)
    }
  }
}
