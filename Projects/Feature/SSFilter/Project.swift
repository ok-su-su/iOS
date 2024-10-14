
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSFilter",
  targets: .feature(
    .sSFilter,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.shareLayer),
      .core(.coreLayers),
    ],
    testDependencies: []
  )
)
