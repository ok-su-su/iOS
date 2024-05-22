
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSSearch",
  targets: .feature(
    .sSSearch,
    testingOptions: [.unitTest],
    dependencies: [
      .core(.coreLayers),
      .share(.designsystem),
    ],
    testDependencies: []
  )
)
