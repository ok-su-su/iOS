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
      .core(.sSNetwork),
      .thirdParty(.ComposableArchitecture),
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen.storyboard",
    ]
  )
)
