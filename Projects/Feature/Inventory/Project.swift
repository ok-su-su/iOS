
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Inventory",
  targets: .feature(
    .inventory,
    testingOptions: [.unitTest],
    dependencies: [
      .core(.coreLayers),
      .share(.designsystem),
    ],
    testDependencies: []
  )
)
