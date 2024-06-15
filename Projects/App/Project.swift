import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "susu",
  targets: .app(
    name: "susu",
    testingOptions: [.unitTest, .uiTest],
    entitlements: nil,
    dependencies: [
      .share(.designsystem),
      .share(.sSAlert),
      .core(.sSRoot),
      .core(.coreLayers),
      .feature(.sent),
      .feature(.inventory),
      .feature(.myPage),
      .feature(.vote),
      .feature(.statistics),
      .feature(.onboarding),
      .feature(.sSLaunchScreen),
      .core(.kakaoLogin),
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen",
      "BGTaskSchedulerPermittedIdentifiers": "com.oksusu.susu.app",
      "CFBundleShortVersionString": "0.1.2",
      "CFBundleVersion": "202406073",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
      // KAKAO InfoPlist
      "LSApplicationQueriesSchemes":
        .dictionary([
          // 카카오톡으로 로그인
          "item 0": "kakaokompassauth",
          // 카카오톡 공유
          "item 1": "kakaolink",
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
    ]
  )
)
