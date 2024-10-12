
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSfilter",
  targets: .feature(
    .sSfilter,
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
