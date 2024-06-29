
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Received",
  targets: .feature(
    .received,
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
