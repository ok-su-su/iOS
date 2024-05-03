
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Inventory",
  targets: .feature(
    .inventory,
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
