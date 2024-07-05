
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSEnvelope",
  targets: .feature(
    .sSEnvelope,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.shareLayer),
      .core(.coreLayers),
    ],
    testDependencies: []
  )
)
