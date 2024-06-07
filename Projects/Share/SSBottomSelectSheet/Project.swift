
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSBottomSelectSheet",
  targets: .custom(
    name: "SSBottomSelectSheet",
    product: .framework
  )
)

