
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSPersistancy",
  targets: .custom(
    name: "SSPersistancy",
    product: .framework
  )
)

