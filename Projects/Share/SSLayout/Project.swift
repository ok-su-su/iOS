
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSLayout",
  targets: .custom(
    name: "SSLayout",
    product: .framework,
    dependencies: [
      .share(.designsystem),
    ]
  )
)
