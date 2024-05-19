
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSToast",
  targets: .custom(
    name: "SSToast",
    product: .framework,
    dependencies: [
      .thirdParty(.ComposableArchitecture),
      .share(.designsystem),
    ]
  )
)
