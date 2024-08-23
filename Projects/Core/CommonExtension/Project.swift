
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "CommonExtension",
  targets: .custom(
    name: "CommonExtension",
    product: .framework
  )
)
