
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSNotification",
  targets: .custom(
    name: "SSNotification",
    product: .framework,
    dependencies: [
      .thirdParty(.ComposableArchitecture),
    ]
  )
)
