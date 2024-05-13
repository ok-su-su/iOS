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
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen.storyboard",
      "BGTaskSchedulerPermittedIdentifiers": "com.oksusu.susu",
      "CFBundleShortVersionString": "0.0.1",
      "CFBundleVersion": "202404201",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
      "LSApplicationQueriesSchemes":
            .dictionary([
                "item 0": "kakaokompassauth",
                "item 1": "kakaolink"
            ]),
      "CFBundleURLTypes":
            .array([
                .dictionary([
                    "CFBundleURLSchemes":
                            .array([
                                .string("${KAKAO_API_KEY}")
                            ]),
                ]),
            ]),
      "KAKAO_NATIVE_APP_KEY": "${KAKAO_NATIVE_APP_KEY}",
    ]
  )
)
