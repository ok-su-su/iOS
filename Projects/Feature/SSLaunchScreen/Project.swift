
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSLaunchScreen",
  targets: .feature(
    .sSLaunchScreen,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.shareLayer),
      .core(.coreLayers),
    ],
    testDependencies: []
  )
)
