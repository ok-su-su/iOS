
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSDataBase",
  targets: .custom(
    name: "SSDataBase",
    product: .framework,
    dependencies: [
      .package(product: "ReamSwift", type: .runtime, condition: .none)
    ]
  ),
  packages: [
    
  ]
)
