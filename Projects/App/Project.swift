import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "susu",
  targets: .app(
    name: "susu",
    testingOptions: .init(arrayLiteral: .uiTest, .unitTest),
    entitlements: nil,
    dependencies: [
      .thirdParty(.Alamofire)
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen.storyboard",
    ]
  )
)
