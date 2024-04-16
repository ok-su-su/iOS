
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSDataBase",
  targets: .custom(
    name: "SSDataBase",
    product: .framework,
    dependencies: [
      .package(product: "RealmSwift", type: .runtime, condition: .none),
    ]
  ),
  packages: [
    .remote(url: "https://github.com/realm/realm-swift.git", requirement: .exact("10.49.1")),
  ]
)
