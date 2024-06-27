import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "susu",
  targets: .app(
    name: "susu",
    productName: "수수(susu)-경조사비 기록 장부",
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
    ]
  )
)
