
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSToast",
  targets: .custom(
    name: "SSToast",
    product: .framework,
    testingOptions: [.uiTest],
    dependencies: [
      .thirdParty(.ComposableArchitecture),
      .share(.designsystem)
    ],
    testDependencies: [.thirdParty(.ComposableArchitecture)]
  )
)
