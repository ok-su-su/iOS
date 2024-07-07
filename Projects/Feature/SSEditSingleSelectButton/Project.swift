
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSEditSingleSelectButton",
  targets: .feature(
    .sSEditSingleSelectButton,
    testingOptions: [.unitTest],
    dependencies: [
      .share(.designsystem),
      .share(.sSLayout),
      .thirdParty(.ComposableArchitecture)
    ],
    testDependencies: []
  )
)
