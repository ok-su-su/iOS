
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSLaunchScreen",
  targets: .feature(
    .sSLaunchScreen,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.designsystem),
      .core(.coreLayers),
    ],
    testDependencies: []
  )
)
