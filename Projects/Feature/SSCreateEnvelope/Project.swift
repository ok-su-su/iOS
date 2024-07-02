
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSCreateEnvelope",
  targets: .feature(
    .sSCreateEnvelope,
    testingOptions: [.unitTest],
    dependencies: [
      .core(.coreLayers),
      .share(.shareLayer),
      .share(.sSLayout),
      .feature(.sSSelectableItems),
    ],
    testDependencies: []
  )
)
