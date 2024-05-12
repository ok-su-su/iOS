
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Profile",
  targets: .feature(
    .profile,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.designsystem),
      .share(.sSAlert),
      .core(.coreLayers)
    ],
    testDependencies: []
  )
)
