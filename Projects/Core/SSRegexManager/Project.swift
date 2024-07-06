
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSRegexManager",
  targets: .custom(
    name: "SSRegexManager",
    product: .framework
  )
)
