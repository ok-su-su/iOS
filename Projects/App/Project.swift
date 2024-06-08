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
      .core(.kakaoLogin),
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen",
      "BGTaskSchedulerPermittedIdentifiers": "com.oksusu.susu.app",
      "CFBundleShortVersionString": "0.0.2",
      "CFBundleVersion": "202406032",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
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
                .string("${KAKAO_API_KEY}"),
              ]),
          ]),
        ]),
      "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
    ]
  )
)
