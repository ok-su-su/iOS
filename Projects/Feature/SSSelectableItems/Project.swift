
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSSelectableItems",
  targets: .feature(
    .sSSelectableItems,
    testingOptions: [.unitTest],
    dependencies: [
      .core(.featureAction),
      .thirdParty(.ComposableArchitecture),
      .share(.designsystem),
    ],
    testDependencies: []
  )
)
