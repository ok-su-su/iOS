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
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen.storyboard",
      "BGTaskSchedulerPermittedIdentifiers": "com.oksusu.susu",
      "CFBundleShortVersionString": "0.0.1",
      "CFBundleVersion": "202404201",
      "UIUserInterfaceStyle": "Light",
      "ITSAppUsesNonExemptEncryption": "No",
    ]
  )
)
