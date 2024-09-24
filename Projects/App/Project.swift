import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "susu",
  targets: .app(
    name: "susu",
    testingOptions: [.unitTest, .uiTest],
    entitlements: .file(path: "susu.entitlements"),
    dependencies: [
      .share(.designsystem),
      .share(.sSAlert),
      .core(.sSRoot),
      .core(.coreLayers),
      .feature(.sent),
      .feature(.received),
      .feature(.myPage),
      .feature(.vote),
      .feature(.statistics),
      .feature(.onboarding),
      .feature(.sSLaunchScreen),
      .feature(.sSLogin),
    ],
    testDependencies: [],
    infoPlist: [
      "CFBundleDisplayName": "수수",
      "UILaunchStoryboardName": "LaunchScreen",
      "BGTaskSchedulerPermittedIdentifiers": "com.oksusu.susu.app",
      "CFBundleShortVersionString": "1.0.5",
      "CFBundleVersion": "2024092329",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
      "AppstoreAPPID": "6503701515",
      "GOOGLE_ANALYTICS_REGISTRATION_WITH_AD_NETWORK_ENABLED": "No", // FireBaseAnalytics settings
      "UISupportedInterfaceOrientations": .array([
        "UIInterfaceOrientationPortrait",
      ]),
      // KAKAO InfoPlist
      "LSApplicationQueriesSchemes":
        .array([
          // 카카오톡으로 로그인
          "kakaokompassauth",
          // 카카오톡 공유
          "kakaolink",
        ]),
      "CFBundleURLTypes":
        .array([
          .dictionary([
            "CFBundleURLSchemes":
              .array([
                .string("kakao${NATIVE_APP_KEY}"),
              ]),
          ]),
        ]),
      "NATIVE_APP_KEY": "${NATIVE_APP_KEY}",
    ],
    additionalScripts: [.firebase]
  )
)
