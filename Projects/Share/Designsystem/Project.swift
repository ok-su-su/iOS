
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Designsystem",
  targets: .custom(
    name: "Designsystem",
    product: .framework,
    resources: "Resources/**"
  )
)
