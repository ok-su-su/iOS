
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSAlert",
  targets: .custom(
    name: "SSAlert",
    product: .framework,
    dependencies: [
      .share(.designsystem),
    ]
  )
)
