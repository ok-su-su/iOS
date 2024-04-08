import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "susu",
  targets: [
    .target(
      name: "susu",
      destinations: .iOS,
      product: .app,
      bundleId: ProjectEnvironment.default.prefixBundleID,
      infoPlist: .extendingDefault(
        with: [
          "UILaunchStoryboardName": "LaunchScreen.storyboard",
        ]
      ),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: []
    ),
  ]
)
