
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSLaunchScreen",
  targets: .feature(
    .sSLaunchScreen,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.designsystem),
      .share(.sSAlert),
      .share(.sSLayout),
      .core(.coreLayers),
      .share(.sSToast),
    ],
    testDependencies: []
  )
)
