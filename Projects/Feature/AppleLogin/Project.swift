
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "AppleLogin",
  targets: .feature(
    .appleLogin,
    testingOptions: [.unitTest],
    dependencies: [
      .core(.sSPersistancy),
    ],
    testDependencies: []
  )
)
