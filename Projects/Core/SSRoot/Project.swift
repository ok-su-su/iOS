
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSRoot",
  targets: .custom(
    name: "SSRoot",
    product: .framework,
    dependencies: [
      .share(.designsystem),
      .thirdParty(.ComposableArchitecture),
    ]
  )
)
