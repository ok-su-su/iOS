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
      .core(.kakaoLogin),
    ],
    testDependencies: [],
    infoPlist: [
      "CFBundleDisplayName": "수수",
      "UILaunchStoryboardName": "LaunchScreen",
      "BGTaskSchedulerPermittedIdentifiers": "com.oksusu.susu.app",
      "CFBundleShortVersionString": "1.0.0",
      "CFBundleVersion": "2024072313",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
      "GOOGLE_ANALYTICS_REGISTRATION_WITH_AD_NETWORK_ENABLED" : "No", // FireBaseAnalytics settings
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
