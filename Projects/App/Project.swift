import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "susu",
  targets: .app(
    name: "susu",
    testingOptions: .init(arrayLiteral: .uiTest, .unitTest),
    entitlements: nil,
    dependencies: [
      .external(name: "Alamofire", condition: .none),
    ],
    testDependencies: [],
    infoPlist: [
      "UILaunchStoryboardName": "LaunchScreen.storyboard",
    ]
  )
)
