
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSDataBase",
  targets: .custom(
    name: "SSDataBase",
    product: .framework,
    dependencies: [
      
    ]
  ),
  packages: [
    .remote(url: "https://github.com/realm/realm-swift", requirement: .exact("10.45.3")),
  ]
)
