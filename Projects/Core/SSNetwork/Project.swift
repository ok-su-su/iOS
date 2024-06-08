
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "SSNetwork",
  targets: .custom(
    name: "SSNetwork",
    product: .framework,
    dependencies: [
      .thirdParty(.Moya),
      .core(.sSPersistancy),
    ]
  )
)
