
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Sent",
  targets: .feature(
    .sent,
    testingOptions: [.unitTest],
    dependencies: [],
    testDependencies: []
  )
)
