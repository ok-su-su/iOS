
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Statistics",
  targets: .feature(
    .statistics,
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
