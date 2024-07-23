
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Vote",
  targets: .feature(
    .vote,
    testingOptions: [.unitTest],
    dependencies: [
      .core(.coreLayers),
      .share(.shareLayer),
      .feature(.sSSearch),
    ],
    testDependencies: []
  )
)
