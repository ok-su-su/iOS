
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSCreateEnvelope",
  targets: .feature(
    .sSCreateEnvelope,
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
