import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "susu",
  targets: .app(
    name: "susu",
    testingOptions: [.unitTest, .uiTest],
    entitlements: nil,
    dependencies: [
      .thirdParty(.Alamofire),
      .share(.designsystem),
      .share(.sSAlert),
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen.storyboard",
    ]
  )
)
